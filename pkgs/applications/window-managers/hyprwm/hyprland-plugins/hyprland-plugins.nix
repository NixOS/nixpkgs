let
  # shared src for upstream hyprland-plugins repo
  # function generating derivations for all plugins in hyprland-plugins
  hyprland-plugins =
    builtins.mapAttrs
      (
        name: description:
        (
          {
            lib,
            cmake,
            fetchFromGitHub,
            mkHyprlandPlugin,
          }:
          let
            version = "0.52.0";

            hyprland-plugins-src = fetchFromGitHub {
              owner = "hyprwm";
              repo = "hyprland-plugins";
              tag = "v${version}";
              hash = "sha256-hr53AWO96ooLCwS1a2v416eT1/aWQZmuQV0ULqhaBTY=";
            };
          in
          mkHyprlandPlugin {
            pluginName = name;
            inherit version;

            src = "${hyprland-plugins-src}/${name}";
            nativeBuildInputs = [ cmake ];
            meta = {
              homepage = "https://github.com/hyprwm/hyprland-plugins";
              description = "Hyprland ${description} plugin";
              license = lib.licenses.bsd3;
              teams = [ lib.teams.hyprland ];
            };
          }
        )
      )
      {
        borders-plus-plus = "multiple borders";
        csgo-vulkan-fix = "CS:GO/CS2 Vulkan fix";
        hyprbars = "window title";
        hyprexpo = "workspaces overview";
        hyprfocus = "flashfocus";
        hyprscrolling = "scrolling layout";
        hyprtrails = "smooth trails behind moving windows";
        hyprwinwrap = "xwinwrap-like";
        xtra-dispatchers = "extra dispatchers";
      };
in
hyprland-plugins
