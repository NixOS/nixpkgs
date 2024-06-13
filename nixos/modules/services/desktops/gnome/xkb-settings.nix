# GNOME Settings Daemon

{ config, lib, ... }:

let
  xcfg = config.services.xserver;

  splitToParts = str: if str == "" then [] else builtins.filter builtins.isString (builtins.split ",\s*" str);

  layouts = splitToParts xcfg.layout;
  variantsUnpadded = splitToParts xcfg.xkbVariant;
  variants =
    let
      padding = lib.max 0 (builtins.length layouts - builtins.length variantsUnpadded);
    in
    variantsUnpadded ++ lib.replicate padding "";
in

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  options = {
    services.gnome.useXkbConfig = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = lib.mdDoc ''
        If enabled, configure the keyboard layout in GNOME Settings Daemon to match [xserver keyboard settings](#opt-services.xserver.layout).
      '';
    };
  };

  config = lib.mkIf config.services.gnome.useXkbConfig {
    assertions = [
      {
        /*
        X appears to ignore the variant option when it is not the same type (string/list) as layout, compare:

            xkbvalidate pc104 us,cz,pl qwerty ""
            xkbvalidate pc104 us qwerty, ""

        and

            xkbvalidate pc104 us,cz,pl qwerty, ""
        */
        assertion = variantsUnpadded != [] -> (builtins.length layouts == 1) == (builtins.length variantsUnpadded == 1);
        message = "services.xserver.layout and services.xserver.xkbVariant should have the same number of comma-separated items.";
      }
    ];

    programs = {
      dconf = {
        profiles = {
          user = {
            databases = [
              {
                # Disallow changing the input settings in Control Center since unlike with NixOS options,
                # there is no merging between databases and user-db would just replace this.
                lockAll = true;

                settings = {
                  "org/gnome/desktop/input-sources" = {
                    sources =
                      if variants != [] then
                        lib.zipListsWith
                          (layout: variant: lib.gvariant.mkTuple [
                            "xkb"
                            "${layout}${lib.optionalString (variant != "") "+" + variant}"
                          ])
                          layouts
                          variants
                      else
                        builtins.map
                          (layout: lib.gvariant.mkTuple [
                            "xkb"
                            layout
                          ])
                          layouts
                      ;
                    xkb-options = splitToParts xcfg.xkbOptions;
                  };
                };
              }
            ];
          };
        };
      };
    };
  };
}
