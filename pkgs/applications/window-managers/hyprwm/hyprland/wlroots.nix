{ fetchFromGitLab
, hyprland
, wlroots
, xwayland
, fetchpatch
, lib
, libdisplay-info
, libliftoff
, hwdata
, hidpiXWayland ? true
, enableXWayland ? true
, nvidiaPatches ? false
}:
let
  libdisplay-info-new = libdisplay-info.overrideAttrs (old: {
    version = "0.1.1+date=2023-03-02";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "emersion";
      repo = old.pname;
      rev = "147d6611a64a6ab04611b923e30efacaca6fc678";
      sha256 = "sha256-/q79o13Zvu7x02SBGu0W5yQznQ+p7ltZ9L6cMW5t/o4=";
    };
  });

  libliftoff-new = libliftoff.overrideAttrs (old: {
    version = "0.5.0-dev";
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "emersion";
      repo = old.pname;
      rev = "d98ae243280074b0ba44bff92215ae8d785658c0";
      sha256 = "sha256-DjwlS8rXE7srs7A8+tHqXyUsFGtucYSeq6X0T/pVOc8=";
    };

    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=sign-conversion"
    ];
  });
in
assert (lib.assertMsg (hidpiXWayland -> enableXWayland) ''
  wlroots-hyprland: cannot have hidpiXWayland when enableXWayland is false.
'');
(wlroots.overrideAttrs
  (old: {
    version = "0.17.0-dev";

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "wlroots";
      repo = "wlroots";
      rev = "7abda952d0000b72d240fe1d41457b9288f0b6e5";
      hash = "sha256-LmI/4Yp/pOOoI4RxLRx9I90NBsiqdRLVOfbATKlgpkg=";
    };

    pname =
      old.pname
      + "-hyprland"
      + (
        if hidpiXWayland
        then "-hidpi"
        else ""
      )
      + (
        if nvidiaPatches
        then "-nvidia"
        else ""
      );

    patches =
      (old.patches or [ ])
      ++ (lib.optionals (enableXWayland && hidpiXWayland) [
        "${hyprland.src}/nix/wlroots-hidpi.patch"
        (fetchpatch {
          url = "https://gitlab.freedesktop.org/wlroots/wlroots/-/commit/18595000f3a21502fd60bf213122859cc348f9af.diff";
          sha256 = "sha256-jvfkAMh3gzkfuoRhB4E9T5X1Hu62wgUjj4tZkJm0mrI=";
          revert = true;
        })
      ])
      ++ (lib.optionals nvidiaPatches [
        (fetchpatch {
          url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-nvidia-format-workaround.patch?h=hyprland-nvidia-screenshare-git&id=2830d3017d7cdd240379b4cc7e5dd6a49cf3399a";
          sha256 = "A9f1p5EW++mGCaNq8w7ZJfeWmvTfUm4iO+1KDcnqYX8=";
        })
      ]);

    postPatch =
      (old.postPatch or "")
      + (
        if nvidiaPatches
        then ''
          substituteInPlace render/gles2/renderer.c --replace "glFlush();" "glFinish();"
        ''
        else ""
      );

    buildInputs =
      old.buildInputs
      ++ [
        hwdata
        libdisplay-info-new
        libliftoff-new
      ];
  })).override {
  xwayland = xwayland.overrideAttrs (old: {
    patches =
      (old.patches or [ ])
      ++ (lib.optionals hidpiXWayland [
        "${hyprland.src}/nix/xwayland-vsync.patch"
        "${hyprland.src}/nix/xwayland-hidpi.patch"
      ]);
  });
}
