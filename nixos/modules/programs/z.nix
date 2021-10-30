with builtins;
{ config, lib, pkgs, ... }:
  let
    l = lib; p = pkgs; t = l.types;

    make-bool-options =
      mapAttrs
        (_: description:
           l.mkOption
             { type = t.bool;
               inherit description;
               default = true;
             }
        );

    make-str-options =
      mapAttrs
        (_: description:
           l.mkOption
             { type = t.nullOr t.str;
               inherit description;
               default = null;
             }
        );

    bool-options =
      { resolve-symlinks = "resolve symlinks";

        prompt-command =
          ''
          Automatically have z handle the PROMPT_COMMAND/precmd.

          Note: if you override your PROMPT_COMMAND after z does, it will override the changes z makes, and z will not work. You can do something like

          export PROMPT_COMMAND="my-prompt-command $PROMPT_COMMAND"

          to fix this.
          '';
      };

    str-options =
      { cmd = "Set the name of the command (defaults: z).";
        data = "Change the datafile (default: $HOME/.z).";
        owner = "To allow usage when in 'sudo -s' mode";
      };
  in
  { options.programs.z =
      { enable = l.mkEnableOption "z";

        max-score =
          l.mkOption
            { type = t.nullOr t.int;
              description = "Lower to age entries out faster (default: 9000)";
              default = null;
            };

        exclude-dirs =
          l.mkOption
            { type = t.listOf t.path;
              description = "An array of directories to exclude";
              default = [];
            };
      }
      // make-bool-options bool-options
      // make-str-options str-options;

    config =
      let cfg = config.programs.z; in
      { environment =
          { interactiveShellInit =
              l.optionalString (cfg.exclude-dirs != [])
                ''
                export _Z_EXCLUDE_DIRS=(${
                concatStringsSep " "
                  (map (v: ''"${v}"'') cfg.exclude-dirs)
                })
                ''
              + l.optionalString cfg.enable ". ${p.z}/z.sh";

            systemPackages = l.optional cfg.enable p.z;

            variables =
              let
                z-var = str: "_Z_${l.toUpper (replaceStrings [ "-" ] [ "_" ] str)}";
                z-var-no = str: z-var "no-${str}";
                foldOnto = f: xs: init: foldl' f init xs;
              in
              l.pipe
                (l.optionalAttrs (cfg.max-score != null)
                   { ${z-var "max-score"} = toString cfg.max-score; }
                )
                [ (foldOnto
                     (acc: n:
                        if cfg.${n} then acc else acc // { ${z-var-no n} = "1"; }
                     )
                     (attrNames bool-options)
                  )

                  (foldOnto
                     (acc: n:
                        let value = cfg.${n}; in
                        if value == null then acc else acc // { ${z-var n} = value; }
                     )
                     (attrNames str-options)
                  )
                ];
          };
      };
  }
