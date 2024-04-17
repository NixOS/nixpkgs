{ fetchFromGitLab
, wlroots
, enableXWayland ? true
}:
wlroots.overrideAttrs
  (old: {
    inherit enableXWayland;
    version = "0.18.0-dev";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "50eae512d9cecbf0b3b1898bb1f0b40fa05fe19b";
      hash = "sha256-wXWIJLd4F2JZeMaihWVDW/yYXCLEC8OpeNJZg9a9ly8=";
    };

    patches = [ ]; # don't inherit old.patches

    pname = "${old.pname}-hyprland";
  })
