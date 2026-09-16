{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkPackageOption
    mkEnableOption
    mkOption
    types
    mkIf
    singleton
    literalExpression
    ;
  cfg = config.services.xserver.windowManager.dwm;
  modifierType = types.either types.str (types.enum [ 0 ]);

  file-src =
    if cfg.config.enable then
      ((import ./file.nix) {
        inherit lib;
        inherit config;
      })
    else
      cfg.customConfig;

  file = pkgs.writeText "config.c" file-src;
in
{

  ###### interface

  options.services.xserver.windowManager.dwm = {
    enable = mkEnableOption "dwm";
    extraSessionCommands = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Shell commands executed just before dwm is started.
      '';
    };
    customConfig = mkOption {
      type = types.str;
      description = ''
        The custom config.h to use in the dwm source code.
        Enabling services.xserver.windowManager.dwm.config.enable will
        override this with the options set within that module.
      '';
    };
    package = mkPackageOption pkgs "dwm" {
      example = ''
        pkgs.dwm.overrideAttrs (oldAttrs: rec {
          patches = [
            (super.fetchpatch {
              url = "https://dwm.suckless.org/patches/steam/dwm-steam-6.2.diff";
              sha256 = "sha256-f3lffBjz7+0Khyn9c9orzReoLTqBb/9gVGshYARGdVc=";
            })
          ];
        })
      '';
    };
    config = {
      enable = mkEnableOption "configuration of dwm in Nix, toggleable as this compiles on your machine";
      finalPackage = mkOption {
        type = types.package;
        readOnly = true;
        defaultText = literalExpression ''
          cfg.package.overrideAttrs (oldAttrs: {
            postPatch = "cp ''${file} config.h; cp ''${file} config.def.h";
          })
        '';
        default =
          let
            finalPackage = cfg.package.overrideAttrs (oldAttrs: {
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
            description = "Move to this tag.";
            type = modifierType;
            default = "MODKEY";
            example = "MODKEY";
          };
          toggleThisTagInView = mkOption {
            description = "Show this tag plus the current.";
            type = modifierType;
            default = "MODKEY|ControlMask";
            example = "MODKEY";
          };
          moveWindowToThisTag = mkOption {
            description = "Move focused window to this tag.";
            type = modifierType;
            default = "MODKEY|ShiftMask";
            example = "MODKEY";
          };
          toggleWindowOnThisTag = mkOption {
            description = "Show the focused window in the tag";
            type = modifierType;
            default = "MODKEY|ControlMask|ShiftMask";
            example = "MODKEY";
          };
        };

        definitions = mkOption {
          description = "The definitions for binding a keybind to a tag";
          type = types.listOf (
            types.submodule {
              options = {
                key = mkOption {
                  description = "The hex or x11 keybind to press alongside the modifier.";
                  type = types.str;
                  example = "XK_9";
                };
                tag = mkOption {
                  description = "The tag to assign to the key.";
                  type = types.int;
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
        description = "Whether to show bar on screen.";
        type = types.bool;
        default = true;
        example = false;
      };
      refreshrate = mkOption {
        description = "The refresh rate per second, for move/resize";
        type = types.int;
        default = 120;
        example = 60;
      };

      topBar = mkOption {
        description = "Whether the bar is on top.";
        type = types.bool;
        default = true;
        example = false;
      };

      buttons = {
        useDefault = mkOption {
          description = "Whether to use the default mouse button bindings.";
          type = types.bool;
          default = true;
          example = false;
        };
        binds = mkOption {
          description = "The function to run when a mouse key is pressed.";
          type = types.listOf (
            types.submodule {
              options = {
                clickArea = mkOption {
                  description = "Where the click occurs (e.g. ClkTagBar, ClkClientWin, ClkRootWin).";
                  type = types.str;
                  example = "ClkTagBar";
                };

                modifier = mkOption {
                  description = "Keyboard modifier key (e.g. 0, Mod1Mask, Mod4Mask, ShiftMask).";
                  type = modifierType;
                  example = "MODKEY";
                };

                button = mkOption {
                  description = "Mouse button (e.g. Button1, Button2, Button3).";
                  type = types.str;
                  example = "Button2";
                };

                function = mkOption {
                  description = "Function to execute (e.g. view, toggleview, movemouse).";
                  type = types.str;
                  example = "toggleview";
                };

                argument = mkOption {
                  description = "Argument for the function (e.g. {0}, {.i = 1}, {.ui = 1<<2}).";
                  type = types.str;
                  example = "{0}";
                };
              };
            }
          );
          default = [ ];
        };
      };

      font = {
        name = mkOption {
          description = "The given name for the font.";
          type = types.str;
          default = "monospace";
          example = "JetbrainsMono NF";
        };
        size = mkOption {
          description = "The font size.";
          type = types.int;
          default = 10;
          example = 12;
        };
      };

      file = {
        prepend = mkOption {
          description = "Custom C code to prepend to the file.";
          type = types.str;
          default = "";
        };
        append = mkOption {
          description = "Custom C code to append to the file.";
          type = types.str;
          default = "";
        };
      };

      borderpx = mkOption {
        description = "Border width in pixels for windows.";
        type = types.int;
        default = 1;
        example = 5;
      };

      modifier = mkOption {
        description = "The default modifier.";
        type = modifierType;
        default = "Mod1Mask";
        example = "Mod4Mask";
      };

      snap = mkOption {
        description = "Snap pixel.";
        type = types.int;
        default = 32;
        example = 16;
      };

      appLauncher = {
        modifier = mkOption {
          description = "The modifier to press alongside the key to launch the app launcher.";
          type = modifierType;
          default = "MODKEY";
          example = "0";
        };
        launchKey = mkOption {
          description = "The key to press alongside the modifier to launch the app launcher.";
          type = types.str;
          default = "XK_p";
          example = "XK_a";
        };
        appCmd = mkOption {
          description = "The application launcher command.";
          type = types.str;
          default = "dmenu_run";
          example = "rofi";
        };
        appArgs = mkOption {
          description = ''
            Arguments to pass to the application launcher command.
            Dmenumon is a variable that contains the current monitor number that dmenu should spawn.
            You can use this variable inside other app launchers.
          '';
          type = types.listOf (
            types.submodule {
              options = {
                flag = mkOption {
                  type = types.str;
                  description = "The flag or argument name.";
                  example = "-m";
                };
                argument = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "The value for the flag.";
                  example = "0";
                };
              };
            }
          );
          example = literalExpression ''[ { flag = "-show"; argument = "drun"; } ]'';
          default = [
            {
              flag = "-m";
              argument = "dmenumon";
            }
            {
              flag = "-fn";
              argument = ''
                "monospace:size=10"
              '';
            }
            {
              flag = "-nb";
              argument = ''
                "#222222"
              '';
            }
            {
              flag = "-nf";
              argument = ''
                "#bbbbbb"
              '';
            }
            {
              flag = "-sb";
              argument = ''
                "#005577"
              '';
            }
            {
              flag = "-sf";
              argument = ''
                "#eeeeee"
              '';
            }
          ];
        };
      };

      terminal = {
        modifier = mkOption {
          description = "The modifier to press alongside the launchKey to launch the terminal";
          type = modifierType;
          default = "MODKEY|ShiftMask";
          example = "0";
        };
        launchKey = mkOption {
          description = "The key to press alongside the modifier to launch the terminal";
          type = types.str;
          default = "XK_Return";
          example = "XK_t";
        };

        appCmd = mkOption {
          description = "The terminal command to launch.";
          type = types.str;
          default = "st";
          example = "kitty";
        };
        appArgs = mkOption {
          description = "Arguments to pass to the terminal command.";
          type = types.listOf (
            types.submodule {
              options = {
                flag = mkOption {
                  type = types.str;
                  description = "The flag or argument name.";
                  example = "-fn";
                };
                argument = mkOption {
                  type = types.nullOr types.str;
                  default = null;
                  description = "The value for the flag. Null for a flag that does not require an argument";
                  example = "monospace:size=12";
                };
              };
            }
          );
          default = [ ];
          example = literalExpression ''[ { flag = "-f"; argument = "monospace:size=12"; } ]'';
        };
      };

      layout = {
        mfact = mkOption {
          description = "Factor of master area size [0.05..0.95].";
          type = types.float;
          default = 0.55;
          example = 0.70;
        };
        nmaster = mkOption {
          description = "Number of clients in master area by default.";
          type = types.int;
          default = 1;
          example = 2;
        };
        resizehints = mkOption {
          description = "Whether to respect size hints in tiled resizing.";
          type = types.bool;
          default = true;
          example = false;
        };
        lockfullscreen = mkOption {
          description = "Whether to force focus on the fullscreen window.";
          type = types.bool;
          default = true;
          example = false;
        };
        layouts = mkOption {
          description = "The layout definitions.";
          type = types.listOf (
            types.submodule {
              options = {
                symbol = mkOption {
                  description = "The icon for the layout such as '[]=' for tiling.";
                  type = types.str;
                  example = "[]=";
                };
                arrangeFunction = mkOption {
                  description = "The function that changes the tiling mode.";
                  type = types.str;
                  example = "tile";
                };
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
          example = literalExpression ''{ symbol = "[=]"; arrageFunction = "tile"; }'';
        };
      };

      colors =
        let
          colorSubmodule = types.listOf (
            types.submodule {
              options = {
                name = mkOption {
                  description = ''
                    The name for the colourscheme, by default there are only two.
                    'SchemeNorm' and 'SchemeSel'.
                  '';
                  type = types.str;
                  example = "SchemeNorm";
                };
                fg = mkOption {
                  description = "The foreground colour for the window.";
                  type = types.str;
                  example = "#ebdbb2";
                };
                bg = mkOption {
                  description = "The background colour for the window.";
                  type = types.str;
                  example = "#282828";
                };
                border = mkOption {
                  description = "The border colour for the window.";
                  type = types.str;
                  example = "#504945";
                };
              };
            }
          );
        in
        mkOption {
          description = "The colorschemes to use on dwm.";
          type = colorSubmodule;
          default = [
            {
              name = "SchemeNorm";
              fg = "#bbbbbb";
              bg = "#222222";
              border = "#444444";
            }
            {
              name = "SchemeSel";
              fg = "#eeeeee";
              bg = "#005577";
              border = "#005577";
            }
          ];
        };

      rules = mkOption {
        description = "The rules for specific windows to follow.";
        type = types.listOf (
          types.submodule {
            options = {
              isFloating = mkEnableOption "floating mode for this window";

              class = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "WM_CLASS class name to match (e.g., \"Firefox\", \"Gimp\").";
              };

              instance = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "WM_CLASS instance name to match.";
              };

              title = mkOption {
                type = types.nullOr types.str;
                default = null;
                description = "Window title to match.";
              };

              tag = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = ''Tag where window should appear (1-9), or `null` for the current tag.'';
              };

              monitor = mkOption {
                type = types.int;
                default = -1;
                description = "Monitor index for the window (-1 for current monitor).";
              };
            };
          }
        );
        default = [
          {
            class = "Gimp";
            instance = null;
            title = null;
            tag = null;
            isFloating = true;
            monitor = -1;
          }
          {
            class = "Firefox";
            instance = null;
            title = null;
            tag = 9;
            isFloating = false;
            monitor = -1;
          }
        ];
      };

      keys = {
        useDefault = mkOption {
          description = "Create default key config, best if you don't want to manually define all keys.";
          type = types.bool;
          default = true;
          example = false;
        };

        bindings = mkOption {
          description = "The definitions for keybindings.";
          type = types.listOf (
            types.submodule {
              options = {
                modifier = mkOption {
                  description = "If unbound will use default modifier. Use 0 for no modifier, or modifier strings like MODKEY|ShiftMask.";
                  type = modifierType;
                  default = "MODKEY";
                };
                key = mkOption {
                  description = "Uses X11 keys, remember that SHIFT will modify the keycode.";
                  type = types.str;
                  default = "XK_p";
                };
                function = mkOption {
                  description = "The function to call once the keybind is pressed.";
                  type = types.str;
                  default = "spawn";
                };
                argument = mkOption {
                  description = "The argument for the function.";
                  type = types.str;
                  default = ".v = dmenucmd";
                };
              };
            }
          );
          default = [ ];
          example = literalExpression ''{ modifier = "MODKEY|ShiftMask"; key = "XK_q"; function = "quit"; argument = "0"; }'';
        };
      };

      tags = mkOption {
        description = "The workspace numbers or 'tags'.";
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
        example = [
          1
          2
          3
        ];
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "dwm";
      start = ''
        ${cfg.extraSessionCommands}

        export _JAVA_AWT_WM_NONREPARENTING=1
        dwm &
        waitPID=$!
      '';
    };

    environment.systemPackages = [
      (if cfg.config.enable then cfg.config.finalPackage else cfg.package)
    ];
  };

  meta.maintainers = with lib.maintainers; [
    twenty-finger-squared
  ];
}
