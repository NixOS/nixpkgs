{
  dotnetCorePackages,
  fetchFromGitHub,
  fetchNpmDeps,
  fetchzip,
  fontconfig,
  lib,
  libICE,
  libSM,
  libX11,
  libXcursor,
  libXext,
  libXi,
  libXrandr,
  liberation_ttf,
  makeFontsConf,
  nodejs,
  npmHooks,
  runCommand,
  stdenvNoCC,
}:

let
  inherit (dotnetCorePackages) systemToDotnetRid;

  dotnet-sdk =
    with dotnetCorePackages;
    combinePackages [
      sdk_7_0_1xx
      runtime_6_0
    ];

  npmDepsFile = ./npm-deps.nix;

in
stdenvNoCC.mkDerivation (
  finalAttrs:
  dotnetCorePackages.addNuGetDeps
    {
      nugetDeps = ./deps.json;
      overrideFetchAttrs = old: rec {
        runtimeIds = map (system: dotnetCorePackages.systemToDotnetRid system) old.meta.platforms;
        buildInputs =
          old.buildInputs
          ++ lib.concatLists (lib.attrValues (lib.getAttrs runtimeIds dotnet-sdk.targetPackages));
      };
    }
    rec {
      pname = "Avalonia";
      version = "11.0.11";

      src = fetchFromGitHub {
        owner = "AvaloniaUI";
        repo = "Avalonia";
        rev = version;
        fetchSubmodules = true;
        hash = "sha256-Du8DEsZKl7rnVH9YZKAWTCpEQ/5HrNlgacgK/46kx/o=";
      };

      patches = [
        # Fix failing tests that use unicode.org
        ./0001-use-files-for-unicode-character-database.patch
        # [ERR] Compile: [...]/Microsoft.NET.Sdk.targets(148,5): error MSB4018: The "GenerateDepsFile" task failed unexpectedly. [/build/source/src/tools/DevAnalyzers/DevAnalyzers.csproj]
        # [ERR] Compile: [...]/Microsoft.NET.Sdk.targets(148,5): error MSB4018: System.IO.IOException: The process cannot access the file '/build/source/src/tools/DevAnalyzers/bin/Release/netstandard2.0/DevAnalyzers.deps.json' because it is being used by another process. [/build/source/src/tools/DevAnalyzers/DevAnalyzers.csproj]
        ./0002-disable-parallel-compile.patch
      ];

      # this needs to be match the version being patched above
      UNICODE_CHARACTER_DATABASE = fetchzip {
        url = "https://www.unicode.org/Public/15.0.0/ucd/UCD.zip";
        hash = "sha256-jj6bX46VcnH7vpc9GwM9gArG+hSPbOGL6E4SaVd0s60=";
        stripRoot = false;
      };

      postPatch =
        ''
          patchShebangs build.sh

          substituteInPlace src/Avalonia.X11/ICELib.cs \
            --replace-fail '"libICE.so.6"' '"${lib.getLib libICE}/lib/libICE.so.6"'
          substituteInPlace src/Avalonia.X11/SMLib.cs \
            --replace-fail '"libSM.so.6"' '"${lib.getLib libSM}/lib/libSM.so.6"'
          substituteInPlace src/Avalonia.X11/XLib.cs \
            --replace-fail '"libX11.so.6"' '"${lib.getLib libX11}/lib/libX11.so.6"' \
            --replace-fail '"libXrandr.so.2"' '"${lib.getLib libXrandr}/lib/libXrandr.so.2"' \
            --replace-fail '"libXext.so.6"' '"${lib.getLib libXext}/lib/libXext.so.6"' \
            --replace-fail '"libXi.so.6"' '"${lib.getLib libXi}/lib/libXi.so.6"' \
            --replace-fail '"libXcursor.so.1"' '"${lib.getLib libXcursor}/lib/libXcursor.so.1"'

          # from RestoreAdditionalProjectSources, which isn't supported by nuget-to-json
          dotnet nuget add source https://pkgs.dev.azure.com/dnceng/public/_packaging/dotnet8-transport/nuget/v3/index.json

          # Tricky way to run npmConfigHook multiple times (borrowed from pagefind)
          (
            local postPatchHooks=() # written to by npmConfigHook
            source ${npmHooks.npmConfigHook}/nix-support/setup-hook
        ''
        +
          # TODO: implement updateScript
          lib.concatMapStrings (
            { path, hash }:
            let
              deps = fetchNpmDeps {
                src = "${src}/${path}";
                inherit hash;
              };
            in
            ''
              npmRoot=${path} npmDeps="${deps}" npmConfigHook
              rm -rf "$TMPDIR/cache"
            ''
          ) (import npmDepsFile)
        + ''
          )
          # Avalonia.Native is normally only packed on darwin.
          substituteInPlace src/Avalonia.Native/Avalonia.Native.csproj \
            --replace-fail \
              '<IsPackable>$(PackAvaloniaNative)</IsPackable>' \
              '<IsPackable>true</IsPackable>'
        '';

      makeCacheWritable = true;

      # CSC : error CS1566: Error reading resource 'pdbstr.exe' -- 'Could not find a part of the path '/build/.nuget-temp/packages/sourcelink/1.1.0/tools/pdbstr.exe'.' [/build/source/nukebuild/_build.csproj]
      linkNugetPackages = true;

      # [WRN] Could not inject value for Build.ApiCompatTool
      # System.Exception: Missing package reference/download.
      # Run one of the following commands:
      #  ---> System.ArgumentException: Could not find package 'Microsoft.DotNet.ApiCompat.Tool' using:
      #  - Project assets file '/build/source/nukebuild/obj/project.assets.json'
      #  - NuGet packages config '/build/source/nukebuild/_build.csproj'
      makeEmptyNupkgInPackages = true;

      FONTCONFIG_FILE =
        let
          fc = makeFontsConf { fontDirectories = [ liberation_ttf ]; };
        in
        runCommand "fonts.conf" { } ''
          substitute ${fc} $out \
            --replace-fail "/etc/" "${fontconfig.out}/etc/"
        '';

      preConfigure = ''
        # closed source (telemetry?) https://github.com/AvaloniaUI/Avalonia/discussions/16878
        dotnet remove packages/Avalonia/Avalonia.csproj package Avalonia.BuildServices
      '';

      runtimeIds = [ (systemToDotnetRid stdenvNoCC.hostPlatform.system) ];

      configurePhase = ''
        runHook preConfigure
        for project in nukebuild/_build.csproj dirs.proj; do
          for rid in $runtimeIds; do
            dotnet restore --runtime "$rid" "$project"
          done
        done
        runHook postConfigure
      '';

      nativeBuildInputs = [
        nodejs
        dotnet-sdk
      ];
      buildInputs = dotnet-sdk.packages;

      buildTarget = "Package";

      buildPhase = ''
        runHook preBuild
        # ValidateApiDiff requires a network connection
        ./build.sh --target $buildTarget --verbosity Verbose --skip ValidateApiDiff
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        mkdir -p "$out/share/nuget/source"
        cp artifacts/nuget/* "$out/share/nuget/source"
        runHook postInstall
      '';

      passthru = {
        updateScript = ./update.bash;
        inherit npmDepsFile;
      };

      meta = {
        homepage = "https://avaloniaui.net/";
        license = [ lib.licenses.mit ];
        maintainers = with lib.maintainers; [ corngood ];
        description = "A cross-platform UI framework for dotnet";
        sourceProvenance = with lib.sourceTypes; [
          fromSource
          binaryNativeCode # npm dependencies contain binaries
        ];
        platforms = dotnet-sdk.meta.platforms;
        broken = stdenvNoCC.hostPlatform.isDarwin;
      };
    }
    finalAttrs
)
