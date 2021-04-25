{ lib, stdenv, fetchgit
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
  version = "unstable-2020-11-02";

  src = fetchgit {
    url = "https://git.sr.ht/~sircmpwn/wio";
    rev = "31b742e473b15a2087be740d1de28bc2afd47a4d";
    sha256 = "1vpvlahv6dmr7vfb11p5cc5ds2y2vfvcb877nkqx18yin6pg357l";
  };

  nativeBuildInputs = [ meson ninja pkg-config makeWrapper ];
  buildInputs = [
    cairo
    libxkbcommon
    udev
    wayland
    wayland-protocols
    wlroots
    mesa # for libEGL
    xwayland
  ];

  postInstall = ''
    wrapProgram $out/bin/wio \
      --prefix PATH ":" "${lib.makeBinPath [ alacritty cage ]}"
  '';

  meta = with lib; {
    description = "That Plan 9 feel, for Wayland";
    longDescription = ''
      Wio is a Wayland compositor for Linux and FreeBSD which has a similar look
      and feel to plan9's rio.
    '';
    homepage = "https://wio-project.org/";
    license = licenses.mit;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ AndersonTorres ];
  };

  passthru.providedSessions = [ "wio" ];
}
# TODO: factor Linux-specific options
