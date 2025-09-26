{
  lib,
  makeSetupHook,
  dart,
  yq,
  jq,
  python3,
}:

{
  dartConfigHook = makeSetupHook {
    name = "dart-config-hook";
    substitutions.yq = "${yq}/bin/yq";
    substitutions.jq = "${jq}/bin/jq";
    substitutions.python3 = lib.getExe (python3.withPackages (ps: with ps; [ pyyaml ]));
    substitutions.packageGraphScript = ../../pub2nix/package-graph.py;
  } ./dart-config-hook.sh;
  dartBuildHook = makeSetupHook {
    name = "dart-build-hook";
    substitutions.yq = "${yq}/bin/yq";
    substitutions.jq = "${jq}/bin/jq";
  } ./dart-build-hook.sh;
  dartInstallHook = makeSetupHook {
    name = "dart-install-hook";
  } ./dart-install-hook.sh;
  dartFixupHook = makeSetupHook {
    name = "dart-fixup-hook";
  } ./dart-fixup-hook.sh;
}
