{ fetchFromGitLab
, wlroots
, libdisplay-info
, libliftoff
, hwdata
}:
wlroots.overrideAttrs
  (old: {
    version = "0.17.0-dev";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "5d639394f3e83b01596dcd166a44a9a1a2583350";
      hash = "sha256-7kvyoA91etzVEl9mkA/EJfB6z/PltxX7Xc4gcr7/xlo=";
    };

    pname = "${old.pname}-hyprland";

    buildInputs = old.buildInputs ++ [
      hwdata
      libdisplay-info
      libliftoff
    ];
  })
