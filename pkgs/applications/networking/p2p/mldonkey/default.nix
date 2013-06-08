{stdenv, fetchurl, ocaml, zlib, bzip2, ncurses, file, gd, libpng }:

stdenv.mkDerivation (rec {
  name = "mldonkey-3.1.3";
  
  src = fetchurl {
    url = "mirror://sourceforge/mldonkey/${name}.tar.bz2";
    sha256 = "1qnr0qzliw4aynf2zhmm5hmrc9bd5vhdq3bi8n88j4nc86gry9bw";
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
