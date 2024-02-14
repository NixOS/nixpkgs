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
      rev = "00b869c1a96f300a8f25da95d624524895e0ddf2";
      hash = "sha256-5HUTG0p+nCJv3cn73AmFHRZdfRV5AD5N43g8xAePSKM=";
    };

    patches = [ ]; # don't inherit old.patches

    pname = "${old.pname}-hyprland";
  })
