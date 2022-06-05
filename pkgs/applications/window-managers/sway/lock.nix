{ lib, stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkg-config, scdoc, wayland-scanner
, wayland, wayland-protocols, libxkbcommon, cairo, gdk-pixbuf, pam
}:

stdenv.mkDerivation rec {
  pname = "swaylock";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "swaylock";
    rev = version;
    sha256 = "sha256-VVGgidmSQWKxZNx9Cd6z52apxpxVfmX3Ut/G9kzfDcY=";
  };

  patches = [
    # remove once when updating to 1.7
    # https://github.com/swaywm/swaylock/pull/235
    (fetchpatch {
      url = "https://github.com/swaywm/swaylock/commit/5a1e6ad79aa7d79b32d36cda39400f3e889b8f8f.diff";
      sha256 = "sha256-ZcZVImUzvng7sluC6q2B5UL8sVunLe4PIfc+tyw48RQ=";
    })
  ];

  strictDeps = true;
  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja pkg-config scdoc wayland-scanner ];
  buildInputs = [ wayland wayland-protocols libxkbcommon cairo gdk-pixbuf pam ];

  mesonFlags = [
    "-Dpam=enabled" "-Dgdk-pixbuf=enabled" "-Dman-pages=enabled"
  ];

  meta = with lib; {
    description = "Screen locker for Wayland";
    longDescription = ''
      swaylock is a screen locking utility for Wayland compositors.
      Important note: If you don't use the Sway module (programs.sway.enable)
      you need to set "security.pam.services.swaylock = {};" manually.
    '';
    inherit (src.meta) homepage;
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
