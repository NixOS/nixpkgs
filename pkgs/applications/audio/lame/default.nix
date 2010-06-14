{stdenv, fetchurl, nasm}:

stdenv.mkDerivation rec {
  name = "lame-3.98.4";
  src = fetchurl {
    url = "mirror://sourceforge/lame/${name}.tar.gz";
    sha256 = "1j3jywv6ic2cy0x0q1a1h6rcl6xmcs5f58xawjdkl8hpcv3l8cdc";
  };

  buildInputs = [ nasm ];

  configureFlags = [ "--enable-nasm" ];

  # Either disable static, or fix the rpath of 'lame' for it to point
  # properly to the libmp3lame shared object.
  dontDisableStatic = true;
}
