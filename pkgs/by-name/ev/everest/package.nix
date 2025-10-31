{
  lib,
  fetchurl,
  fetchFromGitHub,
  buildDotnetModule,
  dotnetCorePackages,
  autoPatchelfHook,
  mono,
  icu,
}:

let
  pname = "everest";
  version = "5935";
  phome = "$out/lib/Celeste";
in
buildDotnetModule {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "EverestAPI";
    repo = "Everest";
    rev = "6a6da718227b357f5b997499e454d5dc5c3e2788";
    fetchSubmodules = true;
    # TODO: use leaveDotGit = true and modify external/MonoMod in postFetch to please SourceLink
    # Microsoft.SourceLink.Common.targets(53,5): warning : Source control information is not available - the generated source link is empty.
    hash = "sha256-qSDcwqjJeb2pNbyriZ/9Gk72DyR5KdIoncXol7JZvFg=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [
    icu # For autoPatchelf
    mono # See upstream README
  ];

  postPatch = ''
    # MonoMod.ILHelpers.Patcher complains at build phase: You must install .NET to run this application.
    sed -i 's|<Exec Command="&quot;|<Exec Command="DOTNET_ROOT=${dotnetCorePackages.runtime_9_0}/share/dotnet \&quot;|' external/MonoMod/tools/Common.IL.targets

    # Moving files after publishing somehow doesn't work. Will do this manually in postInstall.
    sed -i 's|<Move.*/>||' Celeste.Mod.mm/Celeste.Mod.mm.csproj

    autoPatchelf lib-ext/piton/piton-linux_x64
  '';

  dotnet-sdk =
    with dotnetCorePackages;
    sdk_9_0
    // {
      inherit
        (combinePackages [
          sdk_9_0
          sdk_8_0
        ])
        packages
        targetPackages
        ;
    };
  nugetDeps = ./deps.json;

  # Workaround from https://github.com/NixOS/nixpkgs/issues/454432
  # Necessitated by https://github.com/MonoMod/MonoMod/pull/246
  dotnetRestoreFlags = [ "--force-evaluate" ];

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

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Celeste mod loader (don't install; use celestegame instead)";
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
