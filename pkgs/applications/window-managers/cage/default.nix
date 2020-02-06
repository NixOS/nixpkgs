{ stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkgconfig, makeWrapper
, wlroots, wayland, wayland-protocols, pixman, libxkbcommon
, systemd, libGL, libX11
, xwayland ? null
}:

stdenv.mkDerivation rec {
  pname = "cage-unstable";
  version = "2020-01-18";
  # The last stable release (0.1.1) would require at least the following 3 patches:
  # - https://github.com/Hjdskes/cage/commit/33bb3c818c5971777b6f09d8821e7f078d38d262.patch
  # - https://github.com/Hjdskes/cage/commit/51e6c760da51e2b885737d61a61cdc965bb9269d.patch
  # - https://github.com/Hjdskes/cage/commit/84216ca2a417b237ad61c11e2f3ebbcb91681ece.patch
  # Which need to be adapted due to other changes. At this point it seems
  # better to use the current master version until the next stable release.

  src = fetchFromGitHub {
    owner = "Hjdskes";
    repo = "cage";
    rev = "cc1f975c442ebd691b70196d76aa120ead717810";
    sha256 = "1gkqx26pvlw00b3fgx6sh87yyjfzyj51jwxvbf9k117npkrf4b2g";
  };

  nativeBuildInputs = [ meson ninja pkgconfig makeWrapper ];

  buildInputs = [
    wlroots wayland wayland-protocols pixman libxkbcommon
    # TODO: Not specified but required:
    systemd libGL libX11
  ];

  enableParallelBuilding = true;

  mesonFlags = [ "-Dxwayland=${stdenv.lib.boolToString (xwayland != null)}" ];

  postFixup = stdenv.lib.optionalString (xwayland != null) ''
    wrapProgram $out/bin/cage --prefix PATH : "${xwayland}/bin"
  '';

  meta = with stdenv.lib; {
    description = "A Wayland kiosk";
    homepage    = https://www.hjdskes.nl/projects/cage/;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
