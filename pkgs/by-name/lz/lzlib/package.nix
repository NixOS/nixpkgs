{
  lib,
  stdenv,
  fetchurl,
  texinfo,
  lzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lzlib";
  version = "1.15";
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
    hash = "sha256-nUVIDnyBccZPodW+7iy9guaf6+kQ8M5ii4dqj+IUFTQ=";
    # hash from release email
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
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
  };
})
