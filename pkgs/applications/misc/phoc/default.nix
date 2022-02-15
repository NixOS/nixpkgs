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

      # xwayland: Allow to retrieve _NET_STARTUP_ID
      (fetchpatch {
        name = "allow-to-retrieve-net-startup-id.patch";
        url = "https://github.com/swaywm/wlroots/commit/66593071bc90a1cccaeedc636eb6f33c973f5362.patch";
        sha256 = "sha256-yKf/twdUzrII5IakH7AH6LGyPDo9Nl/gIB0pTThSTfY=";
      })
      # xwayland: Allow to retrieve startup-id via _NET_STARTUP_INFO
      (fetchpatch {
        name = "allow-to-retrieve-startup-id-via-net-startup-info.patch";
        url = "https://github.com/swaywm/wlroots/commit/235bb6f2fcb8ee4174215ba74b5bc2f191c5960a.patch";
        sha256 = "sha256-7AWBq12tF/781CmgvTaOvTIiiJMywxRn6eWp+jacdak=";
      })
    ];
  });
in stdenv.mkDerivation rec {
  pname = "phoc";
  version = "0.12.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "Phosh";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-kfMM/YjgAktpOKHNcxxl1FPVbgATPDNRhEJ/sVT1LYs=";
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
    maintainers = with maintainers; [ masipcat zhaofengli ];
    platforms = platforms.linux;
  };
}
