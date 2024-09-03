{ config, lib, pkgs, ... }:
let
  cfg = config.hardware.display;
in
{
  meta.doc = ./display.md;
  meta.maintainers = with lib.maintainers; [
    nazarewk
  ];

  options = {
    hardware.display.edid.enable = lib.mkOption {
      type = with lib.types; bool;
      default = cfg.edid.packages != null;
      defaultText = lib.literalExpression "config.hardware.display.edid.packages != null";
      description = ''
        Enables handling of EDID files
      '';
    };

    hardware.display.edid.packages = lib.mkOption {
      type = with lib.types; listOf package;
      default = [ ];
      description = ''
        List of packages containing EDID binary files at `$out/lib/firmware/edid`.
        Such files will be available for use in `drm.edid_firmware` kernel
        parameter as `edid/<filename>`.

        You can craft one directly here or use sibling options `linuxhw` and `modelines`.
      '';
      example = lib.literalExpression ''
        [
          (pkgs.runCommand "edid-custom" {} '''
            mkdir -p "$out/lib/firmware/edid"
            base64 -d > "$out/lib/firmware/edid/custom1.bin" <<'EOF'
            <insert your base64 encoded EDID file here `base64 < /sys/class/drm/card0-.../edid`>
            EOF
          ''')
        ]
      '';
      apply = list:
        if list == [ ] then null else
        (pkgs.buildEnv {
          name = "firmware-edid";
          paths = list;
          pathsToLink = [ "/lib/firmware/edid" ];
          ignoreCollisions = true;
        }) // {
          compressFirmware = false;
        };
    };

    hardware.display.edid.linuxhw = lib.mkOption {
      type = with lib.types; attrsOf (listOf str);
      default = { };
      description = ''
        Exposes EDID files from users-sourced database at https://github.com/linuxhw/EDID

        Attribute names will be mapped to EDID filenames `<NAME>.bin`.

        Attribute values are lists of `awk` regexp patterns that (together) must match
        exactly one line in either of:
        - [AnalogDisplay.md](https://raw.githubusercontent.com/linuxhw/EDID/master/AnalogDisplay.md)
        - [DigitalDisplay.md](https://raw.githubusercontent.com/linuxhw/EDID/master/DigitalDisplay.md)

        There is no universal way of locating your device config, but here are some practical tips:
        1. locate your device:
          - find your model number (second column)
          - locate manufacturer (first column) and go through the list manually
        2. narrow down results using other columns until there is only one left:
          - `Name` column
          - production date (`Made` column)
          - resolution `Res`
          - screen diagonal (`Inch` column)
          - as a last resort use `ID` from the last column
      '';
      example = lib.literalExpression ''
        {
          PG278Q_2014 = [ "PG278Q" "2014" ];
        }
      '';
      apply = displays:
        if displays == { } then null else
        pkgs.linuxhw-edid-fetcher.override { inherit displays; };
    };

    hardware.display.edid.modelines = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = { };
      description = ''
        Attribute set of XFree86 Modelines automatically converted
        and exposed as `edid/<name>.bin` files in initrd.
        See for more information:
        - https://en.wikipedia.org/wiki/XFree86_Modeline
      '';
      example = lib.literalExpression ''
        {
          "PG278Q_60" = "    241.50   2560 2608 2640 2720   1440 1443 1448 1481   -hsync +vsync";
          "PG278Q_120" = "   497.75   2560 2608 2640 2720   1440 1443 1448 1525   +hsync -vsync";
          "U2711_60" = "     241.50   2560 2600 2632 2720   1440 1443 1448 1481   -hsync +vsync";
        }
      '';
      apply = modelines:
        if modelines == { } then null else
        pkgs.edid-generator.overrideAttrs {
          clean = true;
          passthru.config = modelines;
          modelines = lib.trivial.pipe modelines [
            (lib.mapAttrsToList (name: value:
              lib.throwIfNot (builtins.stringLength name <= 12) "Modeline name must be 12 characters or less"
                ''Modeline "${name}" ${value}''
            ))
            (builtins.map (line: "${line}\n"))
            (lib.strings.concatStringsSep "")
          ];
        };
    };

    hardware.display.outputs = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule ({
        options = {
          edid = lib.mkOption {
            type = with lib.types; nullOr str;
            default = null;
            description = ''
              An EDID filename to be used for configured display, as in `edid/<filename>`.
              See for more information:
              - `hardware.display.edid.packages`
              - https://wiki.archlinux.org/title/Kernel_mode_setting#Forcing_modes_and_EDID
            '';
          };
          mode = lib.mkOption {
            type = with lib.types; nullOr str;
            default = null;
            description = ''
              A `video` kernel parameter (framebuffer mode) configuration for the specific output:

                  <xres>x<yres>[M][R][-<bpp>][@<refresh>][i][m][eDd]

              See for more information:
              - https://docs.kernel.org/fb/modedb.html
              - https://wiki.archlinux.org/title/Kernel_mode_setting#Forcing_modes
            '';
            example = lib.literalExpression ''
              "e"
            '';
          };
        };
      }));
      description = ''
        Hardware/kernel-level configuration of specific outputs.
      '';
      default = { };

      example = lib.literalExpression ''
        {
          edid.modelines."PG278Q_60" = "241.50   2560 2608 2640 2720   1440 1443 1448 1481   -hsync +vsync";
          outputs."DP-1".edid = "PG278Q_60.bin";
          outputs."DP-1".mode = "e";
        }
      '';
    };
  };

  config = lib.mkMerge [
    {
      hardware.display.edid.packages =
        lib.optional (cfg.edid.modelines != null) cfg.edid.modelines
        ++ lib.optional (cfg.edid.linuxhw != null) cfg.edid.linuxhw;

      boot.kernelParams =
        # forcing video modes
        lib.trivial.pipe cfg.outputs [
          (lib.attrsets.filterAttrs (_: spec: spec.mode != null))
          (lib.mapAttrsToList (output: spec: "video=${output}:${spec.mode}"))
        ]
        ++
        # selecting EDID for displays
        lib.trivial.pipe cfg.outputs [
          (lib.attrsets.filterAttrs (_: spec: spec.edid != null))
          (lib.mapAttrsToList (output: spec: "${output}:edid/${spec.edid}"))
          (builtins.concatStringsSep ",")
          (p: lib.optional (p != "") "drm.edid_firmware=${p}")
        ]
      ;
    }
    (lib.mkIf (cfg.edid.packages != null) {
      # services.udev implements hardware.firmware option
      services.udev.enable = true;
      hardware.firmware = [ cfg.edid.packages ];
    })
  ];
}
