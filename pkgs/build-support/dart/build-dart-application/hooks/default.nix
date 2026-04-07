{
  lib,
  makeSetupHook,
  dart,
  yq-go,
  jq,
  python3,
}:

{
  dartConfigHook = makeSetupHook {
    name = "dart-config-hook";
    substitutions = {
      yq = lib.getExe yq-go;
      jq = lib.getExe jq;
      python3 = lib.getExe (python3.withPackages (ps: with ps; [ pyyaml ]));
      packageGraphScript = ../package-graph.py;
      packageConfigScript = ../package-config.py;
    };
  } ./dart-config-hook.sh;
  dartBuildHook = makeSetupHook {
    name = "dart-build-hook";
    substitutions = {
      yq = lib.getExe yq-go;
      jq = lib.getExe jq;
    };
  } ./dart-build-hook.sh;
  dartInstallHook = makeSetupHook {
    name = "dart-install-hook";
  } ./dart-install-hook.sh;
  dartFixupHook = makeSetupHook {
    name = "dart-fixup-hook";
  } ./dart-fixup-hook.sh;
}
