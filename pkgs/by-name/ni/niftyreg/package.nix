{
  lib,
  stdenv,
  fetchurl,
  cmake,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "niftyreg";
  version = "1.3.9";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/nifty_reg-${version}/nifty_reg-${version}.tar.gz";
    sha256 = "07v9v9s41lvw72wpb1jgh2nzanyc994779bd35p76vg8mzifmprl";
  };

  env.NIX_CFLAGS_COMPILE = toString [ "-Wno-error=narrowing" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.0)" "cmake_minimum_required(VERSION 3.10)"
  '';

  meta = with lib; {
    homepage = "http://cmictig.cs.ucl.ac.uk/wiki/index.php/NiftyReg";
    description = "Medical image registration software";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = [ "x86_64-linux" ];
    license = licenses.bsd3;
  };
}
