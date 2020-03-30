{ stdenv
, fetchFromGitHub
, cmake
, bison
, re2c
}:

stdenv.mkDerivation rec {
  pname = "clingcon";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "potassco";
    repo = "${pname}";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "1q7517h10jfvjdk2czq8d6y57r8kr1j1jj2k2ip2qxkpyfigk4rs";
   };

  # deal with clingcon through git submodules recursively importing
  # an outdated version of libpotassco which uses deprecated <xlocale.h> header in .cpp files
  postPatch = ''
    find ./ -type f -exec sed -i 's/<xlocale.h>/<locale.h>/g' {} \;
  '';

  nativeBuildInputs = [ cmake bison re2c ];

  cmakeFlags = [
    "-DCLINGCON_MANAGE_RPATH=ON"
    "-DCLINGO_BUILD_WITH_PYTHON=OFF"
    "-DCLINGO_BUILD_WITH_LUA=OFF"
  ];

  meta = {
    inherit version;
    description = "Extension of clingo to handle constraints over integers";
    license = stdenv.lib.licenses.gpl3; # for now GPL3, next version MIT!
    platforms = stdenv.lib.platforms.unix;
    homepage = "https://potassco.org/";
    downloadPage = "https://github.com/potassco/clingcon/releases/";
    changelog = "https://github.com/potassco/clingcon/releases/tag/v${version}";
  };
}
