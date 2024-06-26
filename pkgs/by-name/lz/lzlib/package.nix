{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  lzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lzlib";
  version = "1.14";
  outputs = [
    "out"
    "info"
  ];

  nativeBuildInputs = [
    texinfo
    lzip
  ];

  src = fetchurl {
    url = "mirror://savannah/lzip/lzlib/lzlib-${finalAttrs.version}.tar.lz";
    sha256 = "e362ecccd82d4dd297df6a51b952c65d2172f9bf41a5c4590d3604d83aa519d3";
    # hash from release email
  };

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace Makefile.in --replace '-Wl,--soname=' '-Wl,-install_name,$(out)/lib/'
  '';

  makeFlags = [
    "CC:=$(CC)"
    "AR:=$(AR)"
  ];
  doCheck = true;

  configureFlags = [ "--enable-shared" ];

  meta = {
    homepage = "https://www.nongnu.org/lzip/lzlib.html";
    description = "Data compression library providing in-memory LZMA compression and decompression functions, including integrity checking of the decompressed data";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ehmry ];
  };
})
