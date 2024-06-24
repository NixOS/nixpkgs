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
            hyprland,
            mkHyprlandPlugin,
          }:
          let
            version = "0.41.1";

            hyprland-plugins-src = fetchFromGitHub {
              owner = "hyprwm";
              repo = "hyprland-plugins";
              rev = "v${version}";
              hash = "sha256-Bw3JRBUZg2kmDwxa/UHvD//gGcNjbftTj2MSeLvx1q8=";
            };
          in
          mkHyprlandPlugin hyprland {
            pluginName = name;
            inherit version;

            src = "${hyprland-plugins-src}/${name}";
            nativeBuildInputs = [ cmake ];
            meta = {
              homepage = "https://github.com/hyprwm/hyprland-plugins";
              description = "Hyprland ${description} plugin";
              license = lib.licenses.bsd3;
              maintainers = with lib.maintainers; [ fufexan ];
              platforms = lib.platforms.linux;
            };
          }
        )
      )
      {
        borders-plus-plus = "multiple borders";
        csgo-vulkan-fix = "CS:GO/CS2 Vulkan fix";
        hyprbars = "window title";
        hyprexpo = "workspaces overview";
        hyprtrails = "smooth trails behind moving windows";
        hyprwinwrap = "xwinwrap-like";
      };
in
hyprland-plugins
