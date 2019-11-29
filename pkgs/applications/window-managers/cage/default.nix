{ stdenv, fetchFromGitHub
, meson, ninja, pkgconfig, makeWrapper
, wlroots, wayland, wayland-protocols, pixman, libxkbcommon
, systemd, libGL, libX11
, xwayland ? null
}:

stdenv.mkDerivation rec {
  pname = "cage";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "Hjdskes";
    repo = pname;
    rev = "v${version}";
    sha256 = "1vp4mfkflrjmlgyx5mkbzdi3iq58m76q7l9dfrsk85xn0642d6q1";
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
