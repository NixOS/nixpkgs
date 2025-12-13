{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
  cfg = config.programs.dwm;

  file = pkgs.writeText "config.c" (
    (import ./file.nix) {
      inherit lib;
      inherit config;
    }
  );
in
{
  options.programs.dwm = {
    enable = lib.mkEnableOption "dwm.";
    package = lib.mkPackageOption pkgs "dwm" { };
    finalPackage = mkOption {
      type = types.package;
      readOnly = true;
      default =
        let
          finalPackage = cfg.package.overrideAttrs (oldAttrs: {
            /*
              if you wish to add your own patch to the module then use the following format to do so.
              make sure to remove anything editing the `config.def.h` to ensure that no errors occur
              ++ (lib.optionals [ <patch-dir> ])
            */
            postPatch = "cp ${file} config.h; cp ${file} config.def.h";
          });
        in
        finalPackage;

      description = ''
        The final dwm package, with the config applied.
      '';
    };

    tagKeys = {
      modifiers = {
        viewOnlyThisTag = mkOption {
          type = types.str;
          default = "MODKEY";
          example = "MODKEY";
        };
        toggleThisTagInView = mkOption {
          type = types.str;
          default = "MODKEY|ControlMask";
          example = "MODKEY";
        };
        moveWindowToThisTag = mkOption {
          type = types.str;
          default = "MODKEY|ShiftMask";
          example = "MODKEY";
        };
        toggleWindowOnThisTag = mkOption {
          type = types.str;
          default = "MODKEY|ControlMask|ShiftMask";
          example = "MODKEY";
        };
      };

      definitions = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              key = mkOption {
                type = types.str;
                default = "XK_1";
                example = "XK_9";
              };
              tag = mkOption {
                type = types.int;
                default = 0;
                example = 9;
              };
            };
          }
        );

        default = [
          {
            key = "XK_1";
            tag = 0;
          }
          {
            key = "XK_2";
            tag = 1;
          }
          {
            key = "XK_3";
            tag = 2;
          }
          {
            key = "XK_4";
            tag = 3;
          }
          {
            key = "XK_5";
            tag = 4;
          }
          {
            key = "XK_6";
            tag = 5;
          }
          {
            key = "XK_7";
            tag = 6;
          }
          {
            key = "XK_8";
            tag = 7;
          }
          {
            key = "XK_9";
            tag = 8;
          }
        ];
      };
    };

    showBar = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Whether to enable show bar.";
    };

    topBar = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "Whether to enable top bar if false then it's on the bottom.";
    };

    buttons = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            click = mkOption { type = types.str; };
            mask = mkOption { type = types.str; };
            button = mkOption { type = types.str; };
            function = mkOption { type = types.str; };
            argument = mkOption { type = types.str; };
          };
        }
      );
      default = [
        {
          click = "ClkLtSymbol";
          mask = "0";
          button = "Button1";
          function = "setlayout";
          argument = "{0}";
        }
        {
          click = "ClkLtSymbol";
          mask = "0";
          button = "Button3";
          function = "setlayout";
          argument = "{.v = &layouts[2]}";
        }
        {
          click = "ClkWinTitle";
          mask = "0";
          button = "Button2";
          function = "zoom";
          argument = "{0}";
        }
        {
          click = "ClkStatusText";
          mask = "0";
          button = "Button2";
          function = "spawn";
          argument = "{.v = termcmd}";
        }
        {
          click = "ClkClientWin";
          mask = "MODKEY";
          button = "Button1";
          function = "movemouse";
          argument = "{0}";
        }
        {
          click = "ClkClientWin";
          mask = "MODKEY";
          button = "Button2";
          function = "togglefloating";
          argument = "{0}";
        }
        {
          click = "ClkClientWin";
          mask = "MODKEY";
          button = "Button3";
          function = "resizemouse";
          argument = "{0}";
        }
        {
          click = "ClkTagBar";
          mask = "0";
          button = "Button1";
          function = "view";
          argument = "{0}";
        }
        {
          click = "ClkTagBar";
          mask = "0";
          button = "Button3";
          function = "toggleview";
          argument = "{0}";
        }
        {
          click = "ClkTagBar";
          mask = "MODKEY";
          button = "Button1";
          function = "tag";
          argument = "{0}";
        }
        {
          click = "ClkTagBar";
          mask = "MODKEY";
          button = "Button3";
          function = "toggletag";
          argument = "{0}";
        }
      ];
    };

    font = {
      name = mkOption {
        type = types.str;
        default = "monospace";
        example = "JetbrainsMono NF";
      };
      size = mkOption {
        type = types.int;
        default = 10;
        example = lib.literalExpresion 12;
        description = "The font size.";
      };

      description = "Font options for dwm.";
    };

    file = {
      description = "Extra file options.";
      prepend = mkOption {
        type = types.str;
        default = "";
        description = "Custom config written in c to prepend to the file.";
      };
      append = mkOption {
        type = types.str;
        default = "";
        description = "Custom config written in C to append to the file.";
      };
    };

    borderpx = mkOption {
      type = types.int;
      default = 1;
      example = lib.literalExpresion 5;
      description = "Border pixel of windows.";
    };

    modifier = mkOption {
      type = types.str;
      default = "Mod1Mask";
      example = "Mod4Mask";
      description = "The default modifier for keybinds.";
    };

    snap = mkOption {
      type = types.int;
      default = 32;
      example = lib.literalExpresion 16;
      description = "Snap pixel.";
    };

    appLauncher = {
      modifier = mkOption {
        type = types.str;
        default = "MODKEY";
      };
      launchKey = mkOption {
        type = types.str;
        default = "XK_p";
      };
      appCmd = mkOption {
        type = types.str;
        example = "dmenu_run";
        description = "The application launcher command.";
      };
      appArgs = mkOption {
        default = [ ];
        type = types.listOf (
          types.submodule {
            options = {
              flag = mkOption {
                type = types.str;
                description = "The flag or argument name.";
              };
              argument = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "The value for the flag.";
              };
            };
          }
        );
        example = [
          {
            flag = "-m";
            argument = "dmenumon";
          }
          {
            flag = "-fn";
            argument = ''"monospace:size=10"'';
          }
          {
            flag = "-nb";
            argument = ''"#222222"'';
          }
          {
            flag = "-nf";
            argument = ''"#bbbbbb"'';
          }
          {
            flag = "-sb";
            argument = ''"#005577"'';
          }
          {
            flag = "-sf";
            argument = ''"#eeeeee"'';
          }
        ];
        description = ''
          Arguments to pass to the application launcher command.
          Dmenumon is a variable that contains the current monitor that dmenu should spawn.
          You can use this variable inside other app launchers.
        '';
      };
    };

    terminal = {
      modifier = mkOption {
        type = types.str;
        default = "MODKEY|ShiftMask";
      };
      launchKey = mkOption {
        type = types.str;
        default = "XK_Return";
      };

      appCmd = mkOption {
        type = types.str;
        example = "st";
        description = "The terminal command to launch.";
      };
      appArgs = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              flag = mkOption {
                type = types.str;
                description = "The flag or argument name.";
              };
              argument = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "The value for the flag.";
              };
            };
          }
        );
        default = [ ];
        example = lib.literalExpresion [ ];
        description = "Arguments to pass to the terminal command.";
      };
    };

    layout = {
      mfact = mkOption {
        type = types.float;
        default = 0.55;
        example = lib.literalExpresion 0.70;
        description = "Factor of master area size [0.05..0.95].";
      };
      nmaster = mkOption {
        type = types.int;
        default = 1;
        example = lib.literalExpresion 2;
        description = "Number of clients in master area by default.";
      };

      resizehints = mkOption {
        type = types.bool;
        default = true;
        example = lib.literalExpresion false;
        description = "1 means respect size hints in tiled resizals.";
      };
      lockfullscreen = mkOption {
        type = types.bool;
        default = true;
        example = lib.literalExpresion false;
        description = "Whether to force focus on the fullscreen window.";
      };

      layouts = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              symbol = mkOption { type = types.str; };
              arrangeFunction = mkOption { type = types.str; };
            };
          }
        );
        default = [
          {
            symbol = "[]=";
            arrangeFunction = "tile";
          }
          {
            symbol = "><>";
            arrangeFunction = "NULL";
          }
          {
            symbol = "[M]";
            arrangeFunction = "monocle";
          }
        ];
        example = {
          symbol = "[]=";
          arrageFunction = "tile";
        };
        description = "The layout definitions.";
      };
    };

    colors =
      let
        colorSubmodule = types.listOf types.submodule {
          options = {
            name = mkOption { type = types.str; };
            fg = mkOption { type = types.str; };
            bg = mkOption { type = types.str; };
            border = mkOption { type = types.str; };
          };
        };
      in
      mkOption {
        default = [
          {
            type = colorSubmodule;
            default = {
              name = "SchemeNorm";
              fg = "#bbbbbb";
              bg = "#222222";
              border = "#444444";
            };
          }
          {
            type = colorSubmodule;
            default = {
              name = "SchemeSel";
              fg = "#eeeeee";
              bg = "#005577";
              border = "#005577";
            };
          }
        ];
      };

    rules = mkOption {
      type = types.listOf (
        types.submodule {
          options = {
            class = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            instance = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            title = mkOption {
              type = types.nullOr types.str;
              default = null;
            };
            tagsMask = mkOption {
              type = types.int;
              default = 0;
            };
            isFloating = lib.mkEnableOption "make window floating";
            monitor = mkOption {
              type = types.int;
              default = -1;
            };
          };
        }
      );
      example = {
        class = "Gimp";
        instance = null;
        title = null;
        tagsMask = 0;
        isFloating = true;
        monitor = -1;
      };
      description = "The rules for specfic windows to follow.";
      default = [
        {
          class = "Gimp";
          instance = null;
          title = null;
          tagsMask = 0;
          isFloating = true;
          monitor = -1;
        }
        {
          class = "Firefox";
          instance = null;
          title = null;
          tagsMask = 256;
          isFloating = false;
          monitor = -1;
        }
      ];
    };

    key = {
      useDefault = mkOption {
        type = types.bool;
        default = true;
        example = lib.literalExpresion false;
        description = "Create default key config, best if you don't want to manually define all keys.";
      };

      keys = mkOption {
        type = types.listOf (
          types.submodule {
            options = {
              modifier = mkOption {
                type = types.either types.str (types.enum [ 0 ]);
                default = "MODKEY";
                description = "If left unbound will use default modifier. Use 0 for no modifier, or modifier strings like MODKEY|ShiftMask.";
              };
              key = mkOption {
                type = types.str;
                default = "XK_p";
                description = "Uses X11 keys, remember that SHIFT will modify the keycode.";
              };
              function = mkOption {
                type = types.str;
                default = "spawn";
                description = "The function to call once the keybind is pressed.";
              };
              argument = mkOption {
                type = types.str;
                default = ".v = dmenucmd";
                description = "The argument for the function.";
              };
            };
          }
        );
        description = "The definitions for keybindings.";
        default = [ ];
        example = {
          modifier = "MODKEY|ShiftMask";
          key = "XK_q";
          function = "quit";
          argument = "0";
        };
      };
    };

    tags = mkOption {
      type = types.listOf types.int;
      default = [
        1
        2
        3
        4
        5
        6
        7
        8
        9
      ];
      description = "The workspace numbers or 'tags'.";
      example = [ 1 ];
    };
  };

  config = lib.mkIf cfg.enable {
    services.xserver = {
      enable = true;
      windowManager.dwm = {
        enable = true;
        package = cfg.finalPackage;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    twenty-finger-squared
  ];
}
