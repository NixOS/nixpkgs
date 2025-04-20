{
  lib,
  stdenv,
  fetchurl,
  libffi,
  getopt,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "copper";
  version = "9.0";

  src = fetchurl {
    url = "https://tibleiz.net/download/copper-${finalAttrs.version}-src.tar.gz";
    hash = "sha256-P6CuAeO7y69uDvkivaSX/8EHkihgk3/Co7K0Skg4ApI=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    getopt
    llvmPackages.libllvm
  ];

  buildInputs = [ libffi ];

  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "Simple imperative language, statically typed with type inference and genericity";
    homepage = "https://tibleiz.net/copper/";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.x86_64;
  };
})
