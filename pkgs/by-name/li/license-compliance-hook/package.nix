{
  lib,
  makeSetupHook,
  callPackage,
  replaceVars,
  jq,
}:

let
  common-licenses = callPackage ./common-licenses.nix { };
in
makeSetupHook
  {
    name = "license-compliance-hook";

    passthru = {
      inherit common-licenses;
    };

    meta = {
      description = "Setup hook for enforcing license compliance";
      maintainers = with lib.maintainers; [ pandapip1 ];
      platforms = lib.platforms.all;
    };
  }
  (
    replaceVars ./setup-hook.sh {
      jq = lib.getExe jq;
      common-licenses = "${common-licenses}/share/common-licenses";
    }
  )
