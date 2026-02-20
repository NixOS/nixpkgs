{
  lib,
  stdenv,
  fetchurl,
  cmake,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "niftyreg";
  version = "1.3.9";

  src = fetchurl {
    url = "mirror://sourceforge/niftyreg/nifty_reg-${finalAttrs.version}/nifty_reg-${finalAttrs.version}.tar.gz";
    sha256 = "07v9v9s41lvw72wpb1jgh2nzanyc994779bd35p76vg8mzifmprl";
  };

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=narrowing" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = {
    homepage = "http://cmictig.cs.ucl.ac.uk/wiki/index.php/NiftyReg";
    description = "Medical image registration software";
    maintainers = with lib.maintainers; [ bcdarwin ];
    platforms = [ "x86_64-linux" ];
    license = lib.licenses.bsd3;
  };
})
