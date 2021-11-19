{ lib, stdenvNoCC, linkFarmFromDrvs, makeWrapper, fetchurl, xml2, dotnetCorePackages, dotnetPackages, cacert }:

{ name ? "${args.pname}-${args.version}"
, enableParallelBuilding ? true
, doCheck ? false
# Flags to pass to `makeWrapper`. This is done to avoid double wrapping.
, makeWrapperArgs ? []

# Flags to pass to `dotnet restore`.
, dotnetRestoreFlags ? []
# Flags to pass to `dotnet build`.
, dotnetBuildFlags ? []
# Flags to pass to `dotnet test`, if running tests is enabled.
, dotnetTestFlags ? []
# Flags to pass to `dotnet install`.
, dotnetInstallFlags ? []
# Flags to pass to dotnet in all phases.
, dotnetFlags ? []

# The binaries that should get installed to `$out/bin`, relative to `$out/lib/$pname/`. These get wrapped accordingly.
# Unfortunately, dotnet has no method for doing this automatically.
# If unset, all executables in the projects root will get installed. This may cause bloat!
, executables ? null
# The packages project file, which contains instructions on how to compile it.
, projectFile ? null
# The NuGet dependency file. This locks all NuGet dependency versions, as otherwise they cannot be deterministically fetched.
# This can be generated using the `nuget-to-nix` tool.
, nugetDeps ? null
# Libraries that need to be available at runtime should be passed through this.
# These get wrapped into `LD_LIBRARY_PATH`.
, runtimeDeps ? []

# Tests to disable. This gets passed to `dotnet test --filter "FullyQualifiedName!={}"`, to ensure compatibility with all frameworks.
# See https://docs.microsoft.com/en-us/dotnet/core/tools/dotnet-test#filter-option-details for more details.
, disabledTests ? []
# The project file to run unit tests against. This is usually the regular project file, but sometimes it needs to be manually set.
, testProjectFile ? projectFile

# The type of build to perform. This is passed to `dotnet` with the `--configuration` flag. Possible values are `Release`, `Debug`, etc.
, buildType ? "Release"
# The dotnet SDK to use.
, dotnet-sdk ? dotnetCorePackages.sdk_5_0
# The dotnet runtime to use.
, dotnet-runtime ? dotnetCorePackages.runtime_5_0
# The dotnet SDK to run tests against. This can differentiate from the SDK compiled against.
, dotnet-test-sdk ? dotnet-sdk
, ... } @ args:

assert projectFile == null -> throw "Defining the `projectFile` attribute is required. This is usually an `.csproj`, or `.sln` file.";

# TODO: Automatically generate a dependency file when a lockfile is present.
# This file is unfortunately almost never present, as Microsoft recommands not to push this in upstream repositories.
assert nugetDeps == null -> throw "Defining the `nugetDeps` attribute is required, as to lock the NuGet dependencies. This file can be generated using the `nuget-to-nix` tool.";

let
  _nugetDeps = linkFarmFromDrvs "${name}-nuget-deps" (import nugetDeps {
    fetchNuGet = { name, version, sha256 }: fetchurl {
      name = "nuget-${name}-${version}.nupkg";
      url = "https://www.nuget.org/api/v2/package/${name}/${version}";
      inherit sha256;
    };
  });

  nuget-source = stdenvNoCC.mkDerivation rec {
    name = "${args.pname}-nuget-source";
    meta.description = "A Nuget source with the dependencies for ${args.pname}";

    nativeBuildInputs = [ dotnetPackages.Nuget xml2 ];
    buildCommand = ''
      export HOME=$(mktemp -d)
      mkdir -p $out/{lib,share}

      nuget sources Add -Name nixos -Source "$out/lib"
      nuget init "${_nugetDeps}" "$out/lib"

      # Generates a list of all unique licenses' spdx ids.
      find "$out/lib" -name "*.nuspec" -exec sh -c \
        "xml2 < {} | grep "license=" | cut -d'=' -f2" \; | sort -u > $out/share/licenses
    '';
  } // { # This is done because we need data from `$out` for `meta`. We have to use overrides as to not hit infinite recursion.
    meta.licence = let
      depLicenses = lib.splitString "\n" (builtins.readFile "${nuget-source}/share/licenses");
      getLicence = spdx: lib.filter (license: license.spdxId or null == spdx) (builtins.attrValues lib.licenses);
    in (lib.flatten (lib.forEach depLicenses (spdx:
      if (getLicence spdx) != [] then (getLicence spdx) else [] ++ lib.optional (spdx != "") spdx
    )));
  };

  package = stdenvNoCC.mkDerivation (args // {
    inherit buildType;

    nativeBuildInputs = args.nativeBuildInputs or [] ++ [ dotnet-sdk cacert makeWrapper ];

    # Stripping breaks the executable
    dontStrip = true;

    DOTNET_NOLOGO = true; # This disables the welcome message.
    DOTNET_CLI_TELEMETRY_OPTOUT = true;

    configurePhase = args.configurePhase or ''
      runHook preConfigure

      export HOME=$(mktemp -d)

      dotnet restore "$projectFile" \
        ${lib.optionalString (!enableParallelBuilding) "--disable-parallel"} \
        -p:ContinuousIntegrationBuild=true \
        -p:Deterministic=true \
        --source "${nuget-source}/lib" \
        "''${dotnetRestoreFlags[@]}" \
        "''${dotnetFlags[@]}"

      runHook postConfigure
    '';

    buildPhase = args.buildPhase or ''
      runHook preBuild

      dotnet build "$projectFile" \
        -maxcpucount:${if enableParallelBuilding then "$NIX_BUILD_CORES" else "1"} \
        -p:BuildInParallel=${if enableParallelBuilding then "true" else "false"} \
        -p:ContinuousIntegrationBuild=true \
        -p:Deterministic=true \
        -p:Version=${args.version} \
        --configuration "$buildType" \
        --no-restore \
        "''${dotnetBuildFlags[@]}"  \
        "''${dotnetFlags[@]}"

      runHook postBuild
    '';

    checkPhase = args.checkPhase or ''
      runHook preCheck

      ${lib.getBin dotnet-test-sdk}/bin/dotnet test "$testProjectFile" \
        -maxcpucount:${if enableParallelBuilding then "$NIX_BUILD_CORES" else "1"} \
        -p:ContinuousIntegrationBuild=true \
        -p:Deterministic=true \
        --configuration "$buildType" \
        --no-build \
        --logger "console;verbosity=normal" \
        ${lib.optionalString (disabledTests != []) "--filter \"FullyQualifiedName!=${lib.concatStringsSep "|FullyQualifiedName!=" disabledTests}\""} \
        "''${dotnetTestFlags[@]}"  \
        "''${dotnetFlags[@]}"

      runHook postCheck
    '';

    installPhase = args.installPhase or ''
      runHook preInstall

      dotnet publish "$projectFile" \
        -p:ContinuousIntegrationBuild=true \
        -p:Deterministic=true \
        --output $out/lib/${args.pname} \
        --configuration "$buildType" \
        --no-build \
        --no-self-contained \
        "''${dotnetInstallFlags[@]}"  \
        "''${dotnetFlags[@]}"
    '' + (if executables != null then ''
      for executable in $executables; do
        execPath="$out/lib/${args.pname}/$executable"

        if [[ -f "$execPath" && -x "$execPath" ]]; then
          makeWrapper "$execPath" "$out/bin/$(basename "$executable")" \
            --set DOTNET_ROOT "${dotnet-runtime}" \
            --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}" \
            "''${gappsWrapperArgs[@]}" \
            "''${makeWrapperArgs[@]}"
        else
          echo "Specified binary \"$executable\" is either not an executable, or does not exist!"
          exit 1
        fi
      done
    '' else ''
      for executable in $out/lib/${args.pname}/*; do
        if [[ -f "$executable" && -x "$executable" && "$executable" != *"dll"* ]]; then
          makeWrapper "$executable" "$out/bin/$(basename "$executable")" \
            --set DOTNET_ROOT "${dotnet-runtime}" \
            --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}" \
            "''${gappsWrapperArgs[@]}" \
            "''${makeWrapperArgs[@]}"
        fi
      done
    '') + ''
      runHook postInstall
    '';
  });
in
  package
