{ config, options, lib, ... }:
let
  path = [ "deployment" "autoLuks" ];
  hasAutoLuksConfig = lib.hasAttrByPath path config && (lib.attrByPath path {} config) != {};

  inherit (config.nixops) enableDeprecatedAutoLuks;
in {
  options.nixops.enableDeprecatedAutoLuks = lib.mkEnableOption (lib.mdDoc "Enable the deprecated NixOps AutoLuks module");

  config = {
    assertions = [
      {
        assertion = if hasAutoLuksConfig then hasAutoLuksConfig && enableDeprecatedAutoLuks else true;
        message = ''
          ⚠️  !!! WARNING !!! ⚠️

            NixOps autoLuks is deprecated. The feature was never widely used and the maintenance did outgrow the benefit.
            If you still want to use the module:
              a) Please raise your voice in the issue tracking usage of the module:
                 https://github.com/NixOS/nixpkgs/issues/62211
              b) make sure you set the `_netdev` option for each of the file
                 systems referring to block devices provided by the autoLuks module.

                 ⚠️ If you do not set the option your system will not boot anymore! ⚠️

                  {
                    fileSystems."/secret" = { options = [ "_netdev" ]; };
                  }

              b) set the option >nixops.enableDeprecatedAutoLuks = true< to remove this error.


            For more details read through the following resources:
              - https://github.com/NixOS/nixops/pull/1156
              - https://github.com/NixOS/nixpkgs/issues/47550
              - https://github.com/NixOS/nixpkgs/issues/62211
              - https://github.com/NixOS/nixpkgs/pull/61321
        '';
      }
    ];
  };

}
