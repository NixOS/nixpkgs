
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.console;

  makeColor = i: concatMapStringsSep "," (x: "0x" + substring (2*i) 2 x);

  isUnicode = hasSuffix "UTF-8" (toUpper config.i18n.defaultLocale);

  optimizedKeymap = pkgs.runCommand "keymap" {
    nativeBuildInputs = [ pkgs.buildPackages.kbd ];
    LOADKEYS_KEYMAP_PATH = "${consoleEnv pkgs.kbd}/share/keymaps/**";
    preferLocalBuild = true;
  } ''
    loadkeys -b ${optionalString isUnicode "-u"} "${cfg.keyMap}" > $out
  '';

  # Sadly, systemd-vconsole-setup doesn't support binary keymaps.
  vconsoleConf = pkgs.writeText "vconsole.conf" ''
    KEYMAP=${cfg.keyMap}
    ${optionalString (cfg.font != null) "FONT=${cfg.font}"}
  '';

  consoleEnv = kbd: pkgs.buildEnv {
    name = "console-env";
    paths = [ kbd ] ++ cfg.packages;
    pathsToLink = [
      "/share/consolefonts"
      "/share/consoletrans"
      "/share/keymaps"
      "/share/unimaps"
    ];
  };
in

{
  ###### interface

  options.console  = {
    enable = mkEnableOption (lib.mdDoc "virtual console") // {
      default = true;
    };

    font = mkOption {
      type = with types; nullOr (either str path);
      default = null;
      example = "LatArCyrHeb-16";
      description = mdDoc ''
        The font used for the virtual consoles.
        Can be `null`, a font name, or a path to a PSF font file.

        Use `null` to let the kernel choose a built-in font.
        The default is 8x16, and, as of Linux 5.3, Terminus 32 bold for display
        resolutions of 2560x1080 and higher.
        These fonts cover the [IBM437][] character set.

        [IBM437]: https://en.wikipedia.org/wiki/Code_page_437
      '';
    };

    keyMap = mkOption {
      type = with types; either str path;
      default = "us";
      example = "fr";
      description = lib.mdDoc ''
        The keyboard mapping table for the virtual consoles.
      '';
    };

    colors = mkOption {
      type = with types; listOf (strMatching "[[:xdigit:]]{6}");
      default = [ ];
      example = [
        "002b36" "dc322f" "859900" "b58900"
        "268bd2" "d33682" "2aa198" "eee8d5"
        "002b36" "cb4b16" "586e75" "657b83"
        "839496" "6c71c4" "93a1a1" "fdf6e3"
      ];
      description = lib.mdDoc ''
        The 16 colors palette used by the virtual consoles.
        Leave empty to use the default colors.
        Colors must be in hexadecimal format and listed in
        order from color 0 to color 15.
      '';

    };

    packages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = lib.mdDoc ''
        List of additional packages that provide console fonts, keymaps and
        other resources for virtual consoles use.
      '';
    };

    useXkbConfig = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        If set, configure the virtual console keymap from the xserver
        keyboard settings.
      '';
    };

    earlySetup = mkOption {
      default = false;
      type = types.bool;
      description = lib.mdDoc ''
        Enable setting virtual console options as early as possible (in initrd).
      '';
    };

  };


  ###### implementation

  config = mkMerge [
    { console.keyMap = with config.services.xserver;
        mkIf cfg.useXkbConfig
          (pkgs.runCommand "xkb-console-keymap" { preferLocalBuild = true; } ''
            '${pkgs.buildPackages.ckbcomp}/bin/ckbcomp' \
              ${optionalString (config.environment.sessionVariables ? XKB_CONFIG_ROOT)
                "-I${config.environment.sessionVariables.XKB_CONFIG_ROOT}"
              } \
              -model '${xkb.model}' -layout '${xkb.layout}' \
              -option '${xkb.options}' -variant '${xkb.variant}' > "$out"
          '');
    }

    (mkIf (!cfg.enable) {
      systemd.services = {
        "serial-getty@ttyS0".enable = false;
        "serial-getty@hvc0".enable = false;
        "getty@tty1".enable = false;
        "autovt@".enable = false;
        systemd-vconsole-setup.enable = false;
      };
    })

    (mkIf cfg.enable (mkMerge [
      { environment.systemPackages = [ pkgs.kbd ];

        # Let systemd-vconsole-setup.service do the work of setting up the
        # virtual consoles.
        environment.etc."vconsole.conf".source = vconsoleConf;
        # Provide kbd with additional packages.
        environment.etc.kbd.source = "${consoleEnv pkgs.kbd}/share";

        boot.initrd.preLVMCommands = mkIf (!config.boot.initrd.systemd.enable) (mkBefore ''
          kbd_mode ${if isUnicode then "-u" else "-a"} -C /dev/console
          printf "\033%%${if isUnicode then "G" else "@"}" >> /dev/console
          loadkmap < ${optimizedKeymap}

          ${optionalString (cfg.earlySetup && cfg.font != null) ''
            setfont -C /dev/console $extraUtils/share/consolefonts/font.psf
          ''}
        '');

        boot.initrd.systemd.contents = {
          "/etc/vconsole.conf".source = vconsoleConf;
          # Add everything if we want full console setup...
          "/etc/kbd" = lib.mkIf cfg.earlySetup { source = "${consoleEnv config.boot.initrd.systemd.package.kbd}/share"; };
          # ...but only the keymaps if we don't
          "/etc/kbd/keymaps" = lib.mkIf (!cfg.earlySetup) { source = "${consoleEnv config.boot.initrd.systemd.package.kbd}/share/keymaps"; };
        };
        boot.initrd.systemd.additionalUpstreamUnits = [
          "systemd-vconsole-setup.service"
        ];
        boot.initrd.systemd.storePaths = [
          "${config.boot.initrd.systemd.package}/lib/systemd/systemd-vconsole-setup"
          "${config.boot.initrd.systemd.package.kbd}/bin/setfont"
          "${config.boot.initrd.systemd.package.kbd}/bin/loadkeys"
          "${config.boot.initrd.systemd.package.kbd.gzip}/bin/gzip" # Fonts and keyboard layouts are compressed
        ] ++ optionals (cfg.font != null && hasPrefix builtins.storeDir cfg.font) [
          "${cfg.font}"
        ] ++ optionals (hasPrefix builtins.storeDir cfg.keyMap) [
          "${cfg.keyMap}"
        ];

        systemd.services.reload-systemd-vconsole-setup =
          { description = "Reset console on configuration changes";
            wantedBy = [ "multi-user.target" ];
            restartTriggers = [ vconsoleConf (consoleEnv pkgs.kbd) ];
            reloadIfChanged = true;
            serviceConfig =
              { RemainAfterExit = true;
                ExecStart = "${pkgs.coreutils}/bin/true";
                ExecReload = "/run/current-system/systemd/bin/systemctl restart systemd-vconsole-setup";
              };
          };
      }

      (mkIf (cfg.colors != []) {
        boot.kernelParams = [
          "vt.default_red=${makeColor 0 cfg.colors}"
          "vt.default_grn=${makeColor 1 cfg.colors}"
          "vt.default_blu=${makeColor 2 cfg.colors}"
        ];
      })

      (mkIf (cfg.earlySetup && cfg.font != null && !config.boot.initrd.systemd.enable) {
        boot.initrd.extraUtilsCommands = ''
          mkdir -p $out/share/consolefonts
          ${if substring 0 1 cfg.font == "/" then ''
            font="${cfg.font}"
          '' else ''
            font="$(echo ${consoleEnv pkgs.kbd}/share/consolefonts/${cfg.font}.*)"
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
    (mkRemovedOptionModule [ "console" "extraTTYs" ] ''
      Since NixOS switched to systemd (circa 2012), TTYs have been spawned on
      demand, so there is no need to configure them manually.
    '')
  ];
}
