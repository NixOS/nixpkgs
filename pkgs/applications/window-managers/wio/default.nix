{ lib
, stdenv
, fetchFromGitHub
, alacritty
, cage
, cairo
, libxkbcommon
, makeWrapper
, mesa
, meson
, ninja
, pkg-config
, udev
, wayland
, wayland-protocols
, wlroots
, xwayland
}:

stdenv.mkDerivation rec {
  pname = "wio";
  version = "0.pre+unstable=2021-06-27";

  src = fetchFromGitHub {
    owner = "museoa";
    repo = pname;
    rev = "e0b258777995055d69e61a0246a6a64985743f42";
    sha256 = "sha256-8H9fOnZsNjjq9XvOv68F4RRglGNluxs5/jp/h4ROLiI=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
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
    inherit (wayland.meta) platforms;
  };

  passthru.providedSessions = [ "wio" ];
}
# TODO: factor Linux-specific options
