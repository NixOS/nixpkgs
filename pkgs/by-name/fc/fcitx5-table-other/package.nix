{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  gettext,
  libime,
  boost,
  fcitx5,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-table-other";
  version = "5.1.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-PoYDy0p/vflwVr5yCox2uSvr4ir6k2Yn1AQHmTw03Zk=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    gettext
    libime
    fcitx5
  ];

  buildInputs = [
    boost
  ];

  meta = {
    description = "Some other tables for Fcitx";
    homepage = "https://github.com/fcitx/fcitx5-table-other";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
  };
}
