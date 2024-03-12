{ fetchFromGitLab
, wlroots
}:
wlroots.overrideAttrs
  (old: {
    version = "0.18.0-dev";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "0cb091f1a2d345f37d2ee445f4ffd04f7f4ec9e5";
      hash = "sha256-Mz6hCtommq7RQfcPnxLINigO4RYSNt23HeJHC6mVmWI=";
    };

    patches = [ ]; # don't inherit old.patches

    pname = "${old.pname}-hyprland";
  })
