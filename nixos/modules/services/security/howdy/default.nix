{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.howdy;
  settingsType = pkgs.formats.ini { };
in
{
  options = {
    services.howdy = {
      enable = lib.mkEnableOption "" // {
        description = ''
          Whether to enable Howdy and its PAM module for face recognition. See
          `services.linux-enable-ir-emitter` for enabling the IR emitter support.

          ::: {.caution}
          Howdy is not a safe alternative to unlocking with your password. It
          can be fooled using a well-printed photo.

          Do **not** use it as the sole authentication method for your system.
          :::
        '';
      };

      package = lib.mkPackageOption pkgs "howdy" { };

      settings = lib.mkOption {
        inherit (settingsType) type;
        default = import ./config.nix;
        description = ''
          Howdy configuration file. Refer to
          <https://github.com/boltgolt/howdy/blob/beta/howdy/src/config.ini>
          for options.
        '';
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];
      environment.etc."howdy/config.ini".source = settingsType.generate "howdy-config.ini" cfg.settings;
      assertions = [
        {
          assertion = !(builtins.elem "v4l2loopback" config.boot.kernelModules);
          message = "Adding 'v4l2loopback' to `boot.kernelModules` causes Howdy to no longer work. Consider adding it to `boot.extraModulePackages` instead.";
        }
      ];
    })
    {
      services.howdy.settings = lib.mapAttrsRecursive (name: lib.mkDefault) (import ./config.nix);
    }
  ];
}
