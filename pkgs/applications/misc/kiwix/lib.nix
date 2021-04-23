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
  version = "9.4.1";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = pname;
    rev = version;
    sha256 = "034nk6l623v78clrs2d0k1vg69sbzrd8c0q79qiqmlkinck1nkxw";
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
