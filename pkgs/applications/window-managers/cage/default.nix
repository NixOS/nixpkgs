{ lib, stdenv, fetchFromGitHub, fetchpatch
, meson, ninja, pkg-config, wayland-scanner, scdoc, makeWrapper
, wlroots, wayland, wayland-protocols, pixman, libxkbcommon
, systemd, libGL, libX11, mesa
, xwayland ? null
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "cage";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "Hjdskes";
    repo = "cage";
    rev = "v${version}";
    sha256 = "0vm96gxinhy48m3x9p1sfldyd03w3gk6iflb7n9kn06j1vqyswr6";
  };

  patches = [
    # The following 4 patches add support for wlroots 0.15.0
    (fetchpatch {
      name = "0001-allow-using-subproject-for-wlroots.patch";
      url = "https://github.com/cage-kiosk/cage/commit/1a3ab3eb3ad0f4a1addb8f9a9427d8b369b19511.patch";
      sha256 = "sha256-+j8wy3P+JbKQ+qGWvtnG4/eig4hnm+pv2wU9i5ju3hw=";
    })
    (fetchpatch {
      name = "0002-move-to-gitHub-actions.patch";
      url = "https://github.com/cage-kiosk/cage/commit/8385b62a9b31028fa356cc4130baebc8b6f4adec.patch";
      sha256 = "sha256-7ihh/qH0JivsN2R1HWYTUwipMRI2JqraWBZzo57C9RU=";
    })
    (fetchpatch {
      name = "0003-tune-compiler-options.patch";
      url = "https://github.com/cage-kiosk/cage/commit/388d60d6b88733330fb83dd440051ee805cc7ec7.patch";
      sha256 = "sha256-3wqbz6SnFam7XmmhZQYDYAz82Z/o4V4asRUKQfawddY=";
    })
    (fetchpatch {
      name = "0004-upgrade-to-wlroots-0_15.patch";
      url = "https://github.com/cage-kiosk/cage/commit/395189fb051ed722c7b10b6cb11caa8f6904079c.patch";
      sha256 = "sha256-98DXunJO5760KXFwz1yjd6k1mZ6Updm3M+EYAhj5dm8=";
    })
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [ meson ninja pkg-config wayland-scanner scdoc makeWrapper ];

  buildInputs = [
    wlroots wayland wayland-protocols pixman libxkbcommon
    mesa # for libEGL headers
    systemd libGL libX11
  ];

  mesonFlags = [ "-Dxwayland=${lib.boolToString (xwayland != null)}" ];

  postFixup = lib.optionalString (xwayland != null) ''
    wrapProgram $out/bin/cage --prefix PATH : "${xwayland}/bin"
  '';

  # Tests Cage using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.cage;

  meta = with lib; {
    description = "A Wayland kiosk that runs a single, maximized application";
    homepage    = "https://www.hjdskes.nl/projects/cage/";
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
