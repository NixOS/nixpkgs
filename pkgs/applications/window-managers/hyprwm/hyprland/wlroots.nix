{ fetchFromGitHub
, wlroots
, enableXWayland ? true
}:
wlroots.overrideAttrs
  (old: {
    inherit enableXWayland;
    version = "0.18.0-dev";

    src = fetchFromGitHub {
      owner = "hyprwm";
      repo = "wlroots-hyprland";
      rev = "611a4f24cd2384378f6e500253983107c6656c64";
      hash = "sha256-vPeZCY+sdiGsz4fl3AVVujfyZyQBz6+vZdkUE4hQ+HI=";
    };

    patches = [ ]; # don't inherit old.patches

    pname = "${old.pname}-hyprland";
  })
