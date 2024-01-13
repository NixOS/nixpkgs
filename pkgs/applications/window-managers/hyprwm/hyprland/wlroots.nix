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
      rev = "5d639394f3e83b01596dcd166a44a9a1a2583350";
      hash = "sha256-7kvyoA91etzVEl9mkA/EJfB6z/PltxX7Xc4gcr7/xlo=";
    };

    patches = [ ]; # don't inherit old.patches

    pname = "${old.pname}-hyprland";
  })
