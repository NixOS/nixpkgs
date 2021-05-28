{ stdenv, fetchFromGitHub
, meson, ninja, pkg-config, wayland, scdoc, makeWrapper
, wlroots, wayland-protocols, pixman, libxkbcommon
, systemd, libGL, libX11
, xwayland ? null
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "cage";
  version = "0.1.2.1";

  src = fetchFromGitHub {
    owner = "Hjdskes";
    repo = "cage";
    rev = "v${version}";
    sha256 = "1i4rm3dpmk7gkl6hfs6a7vwz76ba7yqcdp63nlrdbnq81m9cy2am";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "0.1.2" "${version}"
  '';

  nativeBuildInputs = [ meson ninja pkg-config wayland scdoc makeWrapper ];

  buildInputs = [
    wlroots wayland wayland-protocols pixman libxkbcommon
    systemd libGL libX11
  ];

  mesonFlags = [ "-Dxwayland=${stdenv.lib.boolToString (xwayland != null)}" ];

  postFixup = stdenv.lib.optionalString (xwayland != null) ''
    wrapProgram $out/bin/cage --prefix PATH : "${xwayland}/bin"
  '';

  # Tests Cage using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.cage;

  meta = with stdenv.lib; {
    description = "A Wayland kiosk that runs a single, maximized application";
    homepage    = "https://www.hjdskes.nl/projects/cage/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
