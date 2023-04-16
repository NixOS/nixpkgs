{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, scdoc
, wayland-scanner
, wayland
, wayland-protocols
, libxkbcommon
, cairo
, gdk-pixbuf
, pam
, glib
, dbus
, fprintd
, unstableGitUpdater
}:

stdenv.mkDerivation rec {
  pname = "swaylock-fprintd";
  version = "unstable-20230130";

  src = fetchFromGitHub {
    owner = "SL-RU";
    repo = "swaylock-fprintd";
    rev = "ffd639a785df0b9f39e9a4d77b7c0d7ba0b8ef79";
    hash = "sha256-2VklrbolUV00djPt+ngUyU+YMnJLAHhD+CLZD1wH4ww=";
  };

  postPatch = ''
    substituteInPlace fingerprint/meson.build --replace \
      '/usr/share/dbus-1/interfaces/net.reactivated.Fprint' \
      '${fprintd}/share/dbus-1/interfaces/net.reactivated.Fprint'
  '';

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [
    pkg-config
    glib
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];
  buildInputs = [
    wayland
    wayland-protocols
    libxkbcommon
    cairo
    gdk-pixbuf
    pam
    dbus
  ];

  mesonFlags = [
    "-Dpam=enabled" "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  ];

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "Screen locker for Wayland with fingerprint support via fprintd";
    longDescription = ''
      swaylock-fprintd is a fork of swaylock, a screen locking utility for Wayland compositors,
      with fingerprint support via fprintd. It is compatible with any Wayland compositor which
      implements the ext-session-lock-v1 Wayland protocol.
      Important note: If you don't use the Sway module (programs.sway.enable)
      you need to set "security.pam.services.swaylock = {};" manually.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ lilyinstarlight sebtm ];
    mainProgram = "swaylock";
  };
}
