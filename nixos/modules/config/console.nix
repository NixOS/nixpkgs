{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.console;

  makeColor = i: lib.concatMapStringsSep "," (x: "0x" + lib.substring (2 * i) 2 x);

  isUnicode = lib.hasSuffix "UTF-8" (lib.toUpper config.i18n.defaultLocale);

  optimizedKeymap =
    pkgs.runCommand "keymap"
      {
        nativeBuildInputs = [ pkgs.buildPackages.kbd ];
        LOADKEYS_KEYMAP_PATH = "${consoleEnv pkgs.kbd}/share/keymaps/**";

      }
      ''
        loadkeys -b ${lib.optionalString isUnicode "-u"} "${cfg.keyMap}" > $out
      '';

  # Sadly, systemd-vconsole-setup doesn't support binary keymaps.
  vconsoleConf = pkgs.writeText "vconsole.conf" ''
    KEYMAP=${cfg.keyMap}
    ${lib.optionalString (cfg.font != null) "FONT=${cfg.font}"}
  '';

  consoleEnv =
    kbd:
    pkgs.buildEnv {
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

  options.console = {
    enable = lib.mkEnableOption "virtual console" // {
      default = true;
    };

    font = lib.mkOption {
      type = with lib.types; nullOr (either str path);
      default = null;
      example = "LatArCyrHeb-16";
      description = ''
        The font used for the virtual consoles.
        Can be `null`, a font name, or a path to a PSF font file.

        Use `null` to let the kernel choose a built-in font.
        The default is 8x16, and, as of Linux 5.3, Terminus 32 bold for display
        resolutions of 2560x1080 and higher.
        These fonts cover the [IBM437][] character set.

        [IBM437]: https://en.wikipedia.org/wiki/Code_page_437
      '';
    };

    keyMap = lib.mkOption {
      type = with lib.types; either str path;
      default = "us";
      example = "fr";
      description = ''
        The keyboard mapping table for the virtual consoles.
      '';
    };

    colors = lib.mkOption {
      type = with lib.types; listOf (strMatching "[[:xdigit:]]{6}");
      default = [ ];
      example = [
        "002b36"
        "dc322f"
        "859900"
        "b58900"
        "268bd2"
        "d33682"
        "2aa198"
        "eee8d5"
        "002b36"
        "cb4b16"
        "586e75"
        "657b83"
        "839496"
        "6c71c4"
        "93a1a1"
        "fdf6e3"
      ];
      description = ''
        The 16 colors palette used by the virtual consoles.
        Leave empty to use the default colors.
        Colors must be in hexadecimal format and listed in
        order from color 0 to color 15.
      '';

    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = ''
        List of additional packages that provide console fonts, keymaps and
        other resources for virtual consoles use.
      '';
    };

    useXkbConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        If set, configure the virtual console keymap from the xserver
        keyboard settings.
      '';
    };

    earlySetup = lib.mkOption {
      default = false;
      type = lib.types.bool;
      description = ''
        Enable setting virtual console options as early as possible (in initrd).
      '';
    };

  };

  ###### implementation

  config = lib.mkMerge [
    {
      console.keyMap =
        with config.services.xserver;
        lib.mkIf cfg.useXkbConfig (
          pkgs.runCommand "xkb-console-keymap" { } ''
            '${pkgs.buildPackages.ckbcomp}/bin/ckbcomp' \
              ${
                lib.optionalString (
                  config.environment.sessionVariables ? XKB_CONFIG_ROOT
                ) "-I${config.environment.sessionVariables.XKB_CONFIG_ROOT}"
              } \
              -model '${xkb.model}' -layout '${xkb.layout}' \
              -option '${xkb.options}' -variant '${xkb.variant}' > "$out"
          ''
        );
    }

    (lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          environment.systemPackages = [ pkgs.kbd ];

          # Let systemd-vconsole-setup.service do the work of setting up the
          # virtual consoles.
          environment.etc."vconsole.conf".source = vconsoleConf;
          # Provide kbd with additional packages.
          environment.etc.kbd.source = "${consoleEnv pkgs.kbd}/share";

          boot.initrd.preLVMCommands = lib.mkIf (!config.boot.initrd.systemd.enable) (
            lib.mkBefore ''
              kbd_mode ${if isUnicode then "-u" else "-a"} -C /dev/console
              printf "\033%%${if isUnicode then "G" else "@"}" >> /dev/console
              loadkmap < ${optimizedKeymap}

              ${lib.optionalString (cfg.earlySetup && cfg.font != null) ''
                setfont -C /dev/console $extraUtils/share/consolefonts/font.psf
              ''}
            ''
          );

          boot.initrd.systemd.contents = {
            "/etc/vconsole.conf".source = vconsoleConf;
            # Add everything if we want full console setup...
            "/etc/kbd" = lib.mkIf cfg.earlySetup {
              source = "${consoleEnv config.boot.initrd.systemd.package.kbd}/share";
            };
            # ...but only the keymaps if we don't
            "/etc/kbd/keymaps" = lib.mkIf (!cfg.earlySetup) {
              source = "${consoleEnv config.boot.initrd.systemd.package.kbd}/share/keymaps";
            };
          };
          boot.initrd.systemd.additionalUpstreamUnits = [
            "systemd-vconsole-setup.service"
          ];
          boot.initrd.systemd.storePaths = [
            "${config.boot.initrd.systemd.package}/lib/systemd/systemd-vconsole-setup"
            "${config.boot.initrd.systemd.package.kbd}/bin/setfont"
            "${config.boot.initrd.systemd.package.kbd}/bin/loadkeys"
          ]
          ++ lib.optionals (cfg.font != null && lib.hasPrefix builtins.storeDir cfg.font) [
            "${cfg.font}"
          ]
          ++ lib.optionals (lib.hasPrefix builtins.storeDir cfg.keyMap) [
            "${cfg.keyMap}"
          ];

          systemd.additionalUpstreamSystemUnits = [
            "systemd-vconsole-setup.service"
          ];

          systemd.services.reload-systemd-vconsole-setup = {
            description = "Reset console on configuration changes";
            wantedBy = [ "multi-user.target" ];
            restartTriggers = [
              vconsoleConf
              (consoleEnv pkgs.kbd)
            ];
            reloadIfChanged = true;
            serviceConfig = {
              RemainAfterExit = true;
              ExecStart = "${pkgs.coreutils}/bin/true";
              ExecReload = "/run/current-system/systemd/bin/systemctl restart systemd-vconsole-setup";
            };
          };
        }

        (lib.mkIf (cfg.colors != [ ]) {
          boot.kernelParams = [
            "vt.default_red=${makeColor 0 cfg.colors}"
            "vt.default_grn=${makeColor 1 cfg.colors}"
            "vt.default_blu=${makeColor 2 cfg.colors}"
          ];
        })

        (lib.mkIf (cfg.earlySetup && cfg.font != null && !config.boot.initrd.systemd.enable) {
          boot.initrd.extraUtilsCommands = ''
            mkdir -p $out/share/consolefonts
            ${
              if lib.substring 0 1 cfg.font == "/" then
                ''
                  font="${cfg.font}"
                ''
              else
                ''
                  font="$(echo ${consoleEnv pkgs.kbd}/share/consolefonts/${cfg.font}.*)"
                ''
            }
            if [[ $font == *.gz ]]; then
              gzip -cd $font > $out/share/consolefonts/font.psf
            else
              cp -L $font $out/share/consolefonts/font.psf
            fi
          '';
        })
      ]
    ))
  ];

  imports = [
    (lib.mkRenamedOptionModule [ "i18n" "consoleFont" ] [ "console" "font" ])
    (lib.mkRenamedOptionModule [ "i18n" "consoleKeyMap" ] [ "console" "keyMap" ])
    (lib.mkRenamedOptionModule [ "i18n" "consoleColors" ] [ "console" "colors" ])
    (lib.mkRenamedOptionModule [ "i18n" "consolePackages" ] [ "console" "packages" ])
    (lib.mkRenamedOptionModule [ "i18n" "consoleUseXkbConfig" ] [ "console" "useXkbConfig" ])
    (lib.mkRenamedOptionModule [ "boot" "earlyVconsoleSetup" ] [ "console" "earlySetup" ])
    (lib.mkRenamedOptionModule [ "boot" "extraTTYs" ] [ "console" "extraTTYs" ])
    (lib.mkRemovedOptionModule [ "console" "extraTTYs" ] ''
      Since NixOS switched to systemd (circa 2012), TTYs have been spawned on
      demand, so there is no need to configure them manually.
    '')
  ];
}
