{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.howdy;
  settingsType = pkgs.formats.ini { };

  default_config = {
    core = {
      detection_notice = false;
      timeout_notice = true;
      no_confirmation = false;
      suppress_unknown = false;
      abort_if_ssh = true;
      abort_if_lid_closed = true;
      disabled = false;
      use_cnn = false;
      workaround = "off";
    };

    video = {
      certainty = 3.5;
      timeout = 4;
      device_path = "/dev/video2";
      warn_no_device = true;
      max_height = 320;
      frame_width = -1;
      frame_height = -1;
      dark_threshold = 60;
      recording_plugin = "opencv";
      device_format = "v4l2";
      force_mjpeg = false;
      exposure = -1;
      device_fps = -1;
      rotate = 0;
    };

    snapshots = {
      save_failed = false;
      save_successful = false;
    };

    rubberstamps = {
      enabled = false;
      stamp_rules = "nod		5s		failsafe     min_distance=12";
    };

    debug = {
      end_report = false;
      verbose_stamps = false;
      gtk_stdout = false;
    };
  };
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

          ::: {.note}
          By default, the {option}`config.services.howdy.control` option is set
          to `"required"`, meaning it will act as a second-factor authentication
          in most services. To change this, set the option to `"sufficient"`.
          :::
        '';
      };

      package = lib.mkPackageOption pkgs "howdy" { };

      control = lib.mkOption {
        type = lib.types.str;
        default = "required";
        description = ''
          PAM control flag to use for Howdy.

          Sets the {option}`security.pam.howdy.control` option.

          Refer to {manpage}`pam.conf(5)` for options.
        '';
      };

      settings = lib.mkOption {
        inherit (settingsType) type;
        default = default_config;
        description = ''
          Howdy configuration file. Refer to
          <https://github.com/boltgolt/howdy/blob/d3ab99382f88f043d15f15c1450ab69433892a1c/howdy/src/config.ini>
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
          message = "Adding 'v4l2loopback' to `boot.kernelModules` causes Howdy to no longer work. Consider adding 'v4l2loopback' to `boot.extraModulePackages` instead.";
        }
      ];
    })
    {
      services.howdy.settings = lib.mapAttrsRecursive (name: lib.mkDefault) default_config;
    }
  ];
}
