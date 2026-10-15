{
  lib,
  stdenv,
  fetchFromGitHub,
  libuuid,
}:

stdenv.mkDerivation (finalAttrs: {
  name = "lib" + "crossguid" + "-" + finalAttrs.version;
  pname = "crossguid";
  version = "2016-02-21";

  src = fetchFromGitHub {
    owner = "graeme-hill";
    repo = "crossguid";
    rev = "8f399e8bd4252be9952f3dfa8199924cc8487ca4";
    hash = "sha256-SY8pueA5Sa14Gdfl2/ZH/Q24nJg3Dbu62q1hfIDwScQ=";
  };

  buildInputs = [ libuuid ];

  buildPhase = ''
    $CXX -c guid.cpp -o guid.o $CXXFLAGS -std=c++11 -DGUID_LIBUUID
    $AR rvs libcrossguid.a guid.o
  '';
  installPhase = ''
    mkdir -p $out/{lib,include}
    install -D -m644 libcrossguid.a "$out/lib/libcrossguid.a"
    install -D -m644 guid.h "$out/include/guid.h"
  '';

  meta = {
    description = "Lightweight cross platform C++ GUID/UUID library";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ edwtjo ];
    homepage = "https://github.com/graeme-hill/crossguid";
    platforms = with lib.platforms; linux;
  };

})
