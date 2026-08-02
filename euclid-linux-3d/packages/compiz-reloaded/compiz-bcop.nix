{ lib, stdenv, fetchurl, pkg-config, autoconf, automake, libtool, libxml2, libxslt, util-linux, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "compiz-bcop";
  version = "0.8.18";

  src = fetchurl {
    url = "https://gitlab.com/compiz/compiz-bcop/-/archive/v0.8.18/compiz-bcop-v0.8.18.tar.gz";
    hash = "sha256-tJ16HAxCvvxLtPUofhSvz/FqCw2Mr+nE2e6+dKV/yTg=";
  };

  nativeBuildInputs = [ pkg-config autoconf automake libtool makeWrapper ];
  buildInputs = [ libxml2 libxslt ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  postInstall = ''
    wrapProgram $out/bin/bcop --prefix PATH : ${util-linux}/bin:${libxslt.bin}/bin
  '';

  meta = {
    description = "Compiz Option Code Generator";
    homepage = "https://gitlab.com/compiz/compiz-bcop";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
