{
  enableX11 ? true,
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  xorg,
}:

stdenv.mkDerivation rec {
  pname = "frame";
  version = "2.5.0";
  src = fetchurl {
    url = "https://launchpad.net/frame/trunk/v${version}/+download/${pname}-${version}.tar.xz";
    sha256 = "bc2a20cd3ac1e61fe0461bd3ee8cb250dbcc1fa511fad0686d267744e9c78f3a";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    stdenv
  ]
  ++ lib.optionals enableX11 [
    xorg.xorgserver
    xorg.libX11
    xorg.libXext
    xorg.libXi
  ];

  configureFlags = lib.optional enableX11 "--with-x11";

  meta = {
    homepage = "https://launchpad.net/frame";
    description = "Handles the buildup and synchronization of a set of simultaneous touches";
    mainProgram = "frame-test-x11";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
