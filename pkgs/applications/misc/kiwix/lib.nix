{ lib, stdenv, fetchFromGitHub
, meson, ninja, pkg-config
, python3
, curl
, icu
, libzim
, pugixml
, zlib
, libmicrohttpd
, mustache-hpp
, gtest
}:

stdenv.mkDerivation rec {
  pname = "libkiwix";
  version = "12.0.0";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = pname;
    rev = version;
    sha256 = "sha256-4FxLxJxVhqbeNqX4vorHkROUuRURvE6AXlteIZCEBtc=";
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
    libzim
    pugixml
  ];

  checkInputs = [
    gtest
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs scripts
  '';

  meta = with lib; {
    description = "Common code base for all Kiwix ports";
    homepage = "https://kiwix.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colinsane ];
  };
}
