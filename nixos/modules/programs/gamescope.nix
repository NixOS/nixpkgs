{ config
, lib
, pkgs
, ...
}:
let
  cfg = config.programs.gamescope;

  gamescope =
    let
      wrapperArgs =
        lib.optional (cfg.args != [ ])
          ''--add-flags "${builtins.toString cfg.args}"''
        ++ builtins.attrValues (builtins.mapAttrs (var: val: "--set-default ${var} ${val}") cfg.env);
    in
    pkgs.runCommand "gamescope" { nativeBuildInputs = [ pkgs.makeBinaryWrapper ]; } ''
      mkdir -p $out/bin
      makeWrapper ${cfg.package}/bin/gamescope $out/bin/gamescope --inherit-argv0 \
        ${builtins.toString wrapperArgs}
    '';
in
{
  options.programs.gamescope = {
    enable = lib.mkEnableOption "gamescope, the SteamOS session compositing window manager";

    package = lib.mkPackageOption pkgs "gamescope" { };

    capSysNice = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Add cap_sys_nice capability to the GameScope
        binary so that it may renice itself.
      '';
    };

    args = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--rt" "--prefer-vk-device 8086:9bc4" ];
      description = ''
        Arguments passed to GameScope on startup.
      '';
    };

    env = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        # for Prime render offload on Nvidia laptops.
        # Also requires `hardware.nvidia.prime.offload.enable`.
        {
          __NV_PRIME_RENDER_OFFLOAD = "1";
          __VK_LAYER_NV_optimus = "NVIDIA_only";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        }
      '';
      description = ''
        Default environment variables available to the GameScope process, overridable at runtime.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    security.wrappers = lib.mkIf cfg.capSysNice {
      gamescope = {
        owner = "root";
        group = "root";
        source = "${gamescope}/bin/gamescope";
        capabilities = "cap_sys_nice+pie";
      };
    };

    environment.systemPackages = lib.mkIf (!cfg.capSysNice) [ gamescope ];
  };

  meta.maintainers = with lib.maintainers; [ nrdxp ];
}
