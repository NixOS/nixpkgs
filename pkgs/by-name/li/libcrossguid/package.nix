{
  lib,
  stdenv,
  fetchFromGitHub,
  libuuid,
}:

stdenv.mkDerivation rec {
  name = "lib" + "crossguid" + "-" + version;
  pname = "crossguid";
  version = "2016-02-21";

  src = fetchFromGitHub {
    owner = "graeme-hill";
    repo = "crossguid";
    rev = "8f399e8bd4252be9952f3dfa8199924cc8487ca4";
    sha256 = "1i29y207qqddvaxbn39pk2fbh3gx8zvdprfp35wasj9rw2wjk3s9";
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

  meta = with lib; {
    description = "Lightweight cross platform C++ GUID/UUID library";
    license = licenses.mit;
    maintainers = with maintainers; [ edwtjo ];
    homepage = "https://github.com/graeme-hill/crossguid";
    platforms = with platforms; linux;
  };

}
