{stdenv, fetchurl, nasm}:

stdenv.mkDerivation rec {
  name = "lame-3.99.5";
  src = fetchurl {
    url = "mirror://sourceforge/lame/${name}.tar.gz";
    sha256 = "1zr3kadv35ii6liia0bpfgxpag27xcivp571ybckpbz4b10nnd14";
  };

  buildInputs = [ nasm ];

  configureFlags = [ "--enable-nasm" ];

  # Either disable static, or fix the rpath of 'lame' for it to point
  # properly to the libmp3lame shared object.
  dontDisableStatic = true;
}
