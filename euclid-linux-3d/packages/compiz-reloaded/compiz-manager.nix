{ lib, stdenv, fetchurl, makeWrapper, mesa-demos, pciutils }:

stdenv.mkDerivation rec {
  pname = "compiz-manager";
  version = "0.7.0";

  src = fetchurl {
    url = "https://gitlab.com/compiz/compiz-manager/-/archive/v\0.7.0/compiz-manager-v\0.7.0.tar.gz";
    hash = "sha256-QGr/W6Ax5wm1ANYvmllqkpCA6xEG+/Sfea9/p1wGNEE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    cp compiz-manager $out/bin/
    chmod +x $out/bin/compiz-manager
    wrapProgram $out/bin/compiz-manager \
      --prefix PATH : ${lib.makeBinPath [ mesa-demos pciutils ]}
  '';

  meta = {
    description = "Compiz Manager Wrapper Script";
    homepage = "https://gitlab.com/compiz/compiz-manager";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
