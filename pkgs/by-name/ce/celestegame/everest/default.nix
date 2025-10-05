{
  lib,
  fetchurl,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  autoPatchelfHook,
  mono,
  git,
  icu,
}:

let
  pname = "everest";
  version = "5806";
  phome = "$out/lib/Celeste";
in
buildDotnetModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "EverestAPI";
    repo = "Everest";
    rev = "e47f67fc8c4b0b60b0a75112c5c90704ed371040";
    fetchSubmodules = true;
    leaveDotGit = true; # MonoMod.SourceGen.Internal needs .git
    hash = "sha256-uxb9LwCDGJIc+JN2EqNqHdLLwULnG7Bd/Az3H1zKf3E=";
  };

  nativeBuildInputs = [
    git
    autoPatchelfHook
  ];

  buildInputs = [
    icu # For autoPatchelf
    mono # See upstream README
  ];

  postPatch = ''
    # MonoMod.ILHelpers.Patcher complains at build phase: You must install .NET to run this application.
    sed -i 's|<Exec Command="&quot;|<Exec Command="DOTNET_ROOT=${dotnetCorePackages.runtime_8_0}/share/dotnet \&quot;|' external/MonoMod/tools/Common.IL.targets

    # Moving files after publishing somehow doesn't work. Will do this manually in postInstall.
    sed -i 's|<Move.*/>||' Celeste.Mod.mm/Celeste.Mod.mm.csproj

    autoPatchelf lib-ext/piton/piton-linux_x64
  '';

  dotnet-sdk = dotnetCorePackages.sdk_9_0;

  preConfigure = ''
    # Microsoft.SourceLink.GitHub complains: Unable to determine repository url, the source code won't be available via source link.
    cd external/MonoMod
    git -c safe.directory='*' remote add origin https://github.com/MonoMod/MonoMod.git
    cd ../..
  '';

  nugetDeps = ./deps.json;

  # Needed for ILAsm projects: https://github.com/NixOS/nixpkgs/issues/370754#issuecomment-2571475814
  linkNugetPackages = true;

  # Microsoft.NET.Sdk complains: The process cannot access the file xxx because it is being used by another process.
  enableParallelBuilding = false;

  preBuild = ''
    # See .azure-pipelines/prebuild.ps1
    sed -i 's|0\.0\.0-dev|1.${version}.0-nixos-'$(git rev-parse --short=5 HEAD)'|' Celeste.Mod.mm/Mod/Everest/Everest.cs
    cat Celeste.Mod.mm/Mod/Everest/Everest.cs
    cat <<-EOF > Celeste.Mod.mm/Mod/Helpers/EverestVersion.cs
      namespace Celeste.Mod.Helpers {
        internal static class EverestBuild${version} {
          public static string EverestBuild = "EverestBuild${version}";
        }
      }
    EOF
  '';

  installPath = builtins.replaceStrings [ "$out" ] [ (placeholder "out") ] phome;

  postInstall = ''
    mkdir tmp-EverestSplash
    mv ${phome}/EverestSplash* tmp-EverestSplash
    mv tmp-EverestSplash ${phome}/EverestSplash
    cp ${phome}/piton-runtime.yaml ${phome}/EverestSplash
  '';

  executables = [ ];

  dontPatchELF = true;
  dontStrip = true;
  dontPatchShebangs = true;
  dontAutoPatchelf = true;

  meta = {
    description = "Celeste mod loader";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ ulysseszhan ];
    homepage = "https://everestapi.github.io";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode
      fromSource
    ];
  };
}
