{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, libinput
, gnome
, glib
, gtk3
, wayland
, libdrm
, libxkbcommon
, wlroots
}:

let
  phocWlroots = wlroots.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      # Temporary fix. Upstream report: https://source.puri.sm/Librem5/phosh/-/issues/422
      (fetchpatch {
        name = "0001-Revert-layer-shell-error-on-0-dimension-without-anch.patch";
        url = "https://gitlab.alpinelinux.org/alpine/aports/-/raw/78fde4aaf1a74eb13a3f083cb6dfb29f578c3265/community/wlroots/0001-Revert-layer-shell-error-on-0-dimension-without-anch.patch";
        sha256 = "1zjn7mwdj21z0jsc2mz90cnrzk97yqkiq58qqgpjav4h4dgpfb38";
      })
      # To fix missing header `EGL/eglmesaext.h` dropped upstream
      (fetchpatch {
        name = "0002-stop-including-eglmesaext-h.patch";
        url = "https://github.com/swaywm/wlroots/commit/e18599b05e0f0cbeba11adbd489e801285470eab.patch";
        sha256 = "17ax4dyk0584yhs3lq8ija5bkainjf7psx9c9r50cr4jm9c0i37l";
      })
    ];
  });
in stdenv.mkDerivation rec {
  pname = "phoc";
  version = "0.8.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-QAnJlpFjWJvwxGyenmN4IaI9VFn2jwdXpa8VqAmH7Xw=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook
  ];

  buildInputs = [
    libdrm.dev
    libxkbcommon
    libinput
    glib
    gtk3
    gnome.gnome-desktop
    # For keybindings settings schemas
    gnome.mutter
    wayland
    phocWlroots
  ];

  mesonFlags = ["-Dembed-wlroots=disabled"];

  postPatch = ''
    chmod +x build-aux/post_install.py
    patchShebangs build-aux/post_install.py
  '';

  meta = with lib; {
    description = "Wayland compositor for mobile phones like the Librem 5";
    homepage = "https://gitlab.gnome.org/World/Phosh/phoc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ archseer masipcat zhaofengli ];
    platforms = platforms.linux;
  };
}
