{ stdenv, lib, fetchFromGitHub
, meson, ninja, pkg-config
, python3
, curl
, icu
, pugixml
, zimlib
, zlib
, libmicrohttpd
, mustache-hpp
, gtest
}:


stdenv.mkDerivation rec {
  pname = "kiwix-lib";
  version = "10.1.1";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = pname;
    rev = version;
    sha256 = "sha256-ECvdraN1J5XJQLeZDngxO5I7frwZ8+W8tFpbB7o8UeM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    icu
    zlib
    mustache-hpp
  ];

  propagatedBuildInputs = [
    curl
    libmicrohttpd
    pugixml
    zimlib
  ];

  checkInputs = [
    gtest
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs scripts
  '';
}
