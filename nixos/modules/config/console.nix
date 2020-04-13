
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.console;

  makeColor = i: concatMapStringsSep "," (x: "0x" + substring (2*i) 2 x);

  isUnicode = hasSuffix "UTF-8" (toUpper config.i18n.defaultLocale);

  optimizedKeymap = pkgs.runCommand "keymap" {
    nativeBuildInputs = [ pkgs.buildPackages.kbd ];
    LOADKEYS_KEYMAP_PATH = "${consoleEnv}/share/keymaps/**";
    preferLocalBuild = true;
  } ''
    loadkeys -b ${optionalString isUnicode "-u"} "${cfg.keyMap}" > $out
  '';

  # Sadly, systemd-vconsole-setup doesn't support binary keymaps.
  vconsoleConf = pkgs.writeText "vconsole.conf" ''
    KEYMAP=${cfg.keyMap}
    FONT=${cfg.font}
  '';

  consoleEnv = pkgs.buildEnv {
    name = "console-env";
    paths = [ pkgs.kbd ] ++ cfg.packages;
    pathsToLink = [
      "/share/consolefonts"
      "/share/consoletrans"
      "/share/keymaps"
      "/share/unimaps"
    ];
  };

  setVconsole = !config.boot.isContainer;
in

{
  ###### interface

  options.console  = {
    font = mkOption {
      type = types.str;
      default = "Lat2-Terminus16";
      example = "LatArCyrHeb-16";
      description = ''
        The font used for the virtual consoles.  Leave empty to use
        whatever the <command>setfont</command> program considers the
        default font.
      '';
    };

    keyMap = mkOption {
      type = with types; either str path;
      default = "us";
      example = "fr";
      description = ''
        The keyboard mapping table for the virtual consoles.
      '';
    };

    colors = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [
        "002b36" "dc322f" "859900" "b58900"
        "268bd2" "d33682" "2aa198" "eee8d5"
        "002b36" "cb4b16" "586e75" "657b83"
        "839496" "6c71c4" "93a1a1" "fdf6e3"
      ];
      description = ''
        The 16 colors palette used by the virtual consoles.
        Leave empty to use the default colors.
        Colors must be in hexadecimal format and listed in
        order from color 0 to color 15.
      '';

    };

    packages = mkOption {
      type = types.listOf types.package;
      default = with pkgs.kbdKeymaps; [ dvp neo ];
      defaultText = ''with pkgs.kbdKeymaps; [ dvp neo ]'';
      description = ''
        List of additional packages that provide console fonts, keymaps and
        other resources for virtual consoles use.
      '';
    };

    extraTTYs = mkOption {
      default = [];
      type = types.listOf types.str;
      example = ["tty8" "tty9"];
      description = ''
        TTY (virtual console) devices, in addition to the consoles on
        which mingetty and syslogd run, that must be initialised.
        Only useful if you have some program that you want to run on
        some fixed console.  For example, the NixOS installation CD
        opens the manual in a web browser on console 7, so it sets
        <option>console.extraTTYs</option> to <literal>["tty7"]</literal>.
      '';
    };

    useXkbConfig = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If set, configure the virtual console keymap from the xserver
        keyboard settings.
      '';
    };

    earlySetup = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Enable setting virtual console options as early as possible (in initrd).
      '';
    };

  };


  ###### implementation

  config = mkMerge [
    { console.keyMap = with config.services.xserver;
        mkIf cfg.useXkbConfig
          (pkgs.runCommand "xkb-console-keymap" { preferLocalBuild = true; } ''
            '${pkgs.ckbcomp}/bin/ckbcomp' -model '${xkbModel}' -layout '${layout}' \
              -option '${xkbOptions}' -variant '${xkbVariant}' > "$out"
          '');
    }

    (mkIf (!setVconsole) {
      systemd.services.systemd-vconsole-setup.enable = false;
    })

    (mkIf setVconsole (mkMerge [
      { environment.systemPackages = [ pkgs.kbd ];

        # Let systemd-vconsole-setup.service do the work of setting up the
        # virtual consoles.
        environment.etc."vconsole.conf".source = vconsoleConf;
        # Provide kbd with additional packages.
        environment.etc.kbd.source = "${consoleEnv}/share";

        boot.initrd.preLVMCommands = mkBefore ''
          kbd_mode ${if isUnicode then "-u" else "-a"} -C /dev/console
          printf "\033%%${if isUnicode then "G" else "@"}" >> /dev/console
          loadkmap < ${optimizedKeymap}

          ${optionalString cfg.earlySetup ''
            setfont -C /dev/console $extraUtils/share/consolefonts/font.psf
          ''}
        '';

        systemd.services.systemd-vconsole-setup =
          { before = [ "display-manager.service" ];
            after = [ "systemd-udev-settle.service" ];
            restartTriggers = [ vconsoleConf consoleEnv ];
          };
      }

      (mkIf (cfg.colors != []) {
        boot.kernelParams = [
          "vt.default_red=${makeColor 0 cfg.colors}"
          "vt.default_grn=${makeColor 1 cfg.colors}"
          "vt.default_blu=${makeColor 2 cfg.colors}"
        ];
      })

      (mkIf cfg.earlySetup {
        boot.initrd.extraUtilsCommands = ''
          mkdir -p $out/share/consolefonts
          ${if substring 0 1 cfg.font == "/" then ''
            font="${cfg.font}"
          '' else ''
            font="$(echo ${consoleEnv}/share/consolefonts/${cfg.font}.*)"
          ''}
          if [[ $font == *.gz ]]; then
            gzip -cd $font > $out/share/consolefonts/font.psf
          else
            cp -L $font $out/share/consolefonts/font.psf
          fi
        '';
      })
    ]))
  ];

  imports = [
    (mkRenamedOptionModule [ "i18n" "consoleFont" ] [ "console" "font" ])
    (mkRenamedOptionModule [ "i18n" "consoleKeyMap" ] [ "console" "keyMap" ])
    (mkRenamedOptionModule [ "i18n" "consoleColors" ] [ "console" "colors" ])
    (mkRenamedOptionModule [ "i18n" "consolePackages" ] [ "console" "packages" ])
    (mkRenamedOptionModule [ "i18n" "consoleUseXkbConfig" ] [ "console" "useXkbConfig" ])
    (mkRenamedOptionModule [ "boot" "earlyVconsoleSetup" ] [ "console" "earlySetup" ])
    (mkRenamedOptionModule [ "boot" "extraTTYs" ] [ "console" "extraTTYs" ])
  ];
}
