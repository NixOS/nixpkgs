{ lib
, stdenv
, fetchFromBitbucket
, meson
, ninja
, pkg-config
, alacritty
, cage
, cairo
, libxkbcommon
, udev
, wayland
, wayland-protocols
, wlroots
, mesa
, xwayland
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "wio";
  version = "0.0.0+unstable=2021-06-27";

  src = fetchFromBitbucket {
    owner = "anderson_torres";
    repo = pname;
    rev = "e0b258777995055d69e61a0246a6a64985743f42";
    sha256 = "sha256-8H9fOnZsNjjq9XvOv68F4RRglGNluxs5/jp/h4ROLiI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    makeWrapper
  ];
  buildInputs = [
    cairo
    libxkbcommon
    mesa # for libEGL
    udev
    wayland
    wayland-protocols
    wlroots
    xwayland
  ];

  postInstall = ''
    wrapProgram $out/bin/wio \
      --prefix PATH ":" "${lib.makeBinPath [ alacritty cage ]}"
  '';

  meta = with lib; {
    homepage = "https://wio-project.org/";
    description = "That Plan 9 feel, for Wayland";
    longDescription = ''
      Wio is a Wayland compositor for Linux and FreeBSD which has a similar look
      and feel to plan9's rio.
    '';
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; linux;
  };

  passthru.providedSessions = [ "wio" ];
}
# TODO: factor Linux-specific options
