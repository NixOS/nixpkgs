{stdenv, fetchurl, ocaml, zlib, bzip2, ncurses, file, gd, libpng }:

stdenv.mkDerivation (rec {
  name = "mldonkey-3.1.5";
  
  src = fetchurl {
    url = "mirror://sourceforge/mldonkey/${name}.tar.bz2";
    sha256 = "1jqik6b09p27ckssppfiqpph7alxbgpnf9w1s0lalmi3qyyd9ybl";
  };
  
  meta = {
    description = "Client for many p2p networks, with multiple frontends";
    homepage = http://mldonkey.sourceforge.net/;
  };

  buildInputs = [ ocaml zlib ncurses bzip2 file gd libpng ];
  configureFlags = [ "--disable-gui" ];
} // (if !ocaml.nativeCompilers then
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
