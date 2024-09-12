{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, nsplist
, pugixml
}:

stdenv.mkDerivation {
  pname = "plistcpp";
  version = "0-unstable-2017-04-11";

  src = fetchFromGitHub {
    owner = "matthewbauer";
    repo = "PlistCpp";
    rev = "11615deab3369356a182dabbf5bae30574967264";
    hash = "sha256-+3uw1XgYZMRdp+PhWRmjBJZNxGlX9PhFIsbuVPcyVoI=";
  };

  postPatch = ''
    sed -i "1i #include <algorithm>" src/Plist.cpp
  '';

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    nsplist
    pugixml
  ];

  meta = with lib; {
    maintainers = with maintainers; [ matthewbauer ];
    description = "CPP bindings for Plist";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
