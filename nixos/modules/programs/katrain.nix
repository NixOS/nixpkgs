{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.katrain;
in
{
  options.programs.katrain = {
    enable = lib.mkEnableOption "katrain";

    withXClip = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to include xclip for copy-paste functions on X11";
    };

    withWlClipboard = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to include wl-clipboard-x11 for copy-paste functions on Wayland";
    };

    katago = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to include and patch katago into katrain";
      };

      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        defaultText = "pkgs.katagoCPU";
        description = "The katago package to patch into katrain";
      };
    };
  };

  config =
    let
      katagoPkg = if cfg.katago.package != null then cfg.katago.package else pkgs.katagoCPU;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        (pkgs.katrain.overrideAttrs (
          old:
          (lib.optionalAttrs cfg.katago.enable {
            patchPhase = ''
              ${old.patchPhase or ""}
              echo "patching katago binary path..."

              substituteInPlace katrain/core/engine.py \
                --replace-fail 'exe = self.get_engine_path(config.get("katago", "").strip())' \
                'exe = self.get_engine_path("${katagoPkg}/bin/katago")'

              substituteInPlace katrain/core/contribute_engine.py \
                --replace-fail 'exe = self.get_engine_path(self.config.get("katago"))' \
                'exe = self.get_engine_path("${katagoPkg}/bin/katago")'
            '';
          })
          // {
            propagatedBuildInputs =
              (old.propagatedBuildInputs or [ ])
              ++ lib.optionals cfg.katago.enable [ katagoPkg ]
              ++ lib.optionals cfg.withXClip [ pkgs.xclip ]
              ++ lib.optionals cfg.withWlClipboard [ pkgs.wl-clipboard-x11 ];
          }
        ))
      ];
    };
}
