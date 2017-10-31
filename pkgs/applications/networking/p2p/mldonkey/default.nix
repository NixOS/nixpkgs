{ stdenv, fetchurl, ocamlPackages, zlib, bzip2, ncurses, file, gd, libpng, libjpeg }:

stdenv.mkDerivation (rec {
  name = "mldonkey-3.1.6";

  src = fetchurl {
    url = https://github.com/ygrek/mldonkey/releases/download/release-3-1-6/mldonkey-3.1.6.tar.bz2;
    sha256 = "0g84islkj72ymp0zzppcj9n4r21h0vlghnq87hv2wg580mybadhv";
  };

  preConfigure = stdenv.lib.optionalString (ocamlPackages.camlp4 != null) ''
    substituteInPlace Makefile --replace '+camlp4' \
      '${ocamlPackages.camlp4}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/camlp4'
  '';

  buildInputs = [ zlib ncurses bzip2 file gd libpng libjpeg ] ++
  (with ocamlPackages; [ ocaml camlp4 ]);
  configureFlags = [ "--disable-gui" ];

  meta = {
    description = "Client for many p2p networks, with multiple frontends";
    homepage = http://mldonkey.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.unix;
  };
} // (if !ocamlPackages.ocaml.nativeCompilers then
{
  # Byte code compilation (the ocaml opt compiler is not supported in some platforms)
  buildPhase = "make mlnet.byte";
  installPhase = ''
    mkdir -p $out/bin
    cp mlnet.byte $out/bin/mlnet
  '';

  # ocaml bytecode selfcontained binaries loose the bytecode if stripped
  dontStrip = true;
} else {}))
