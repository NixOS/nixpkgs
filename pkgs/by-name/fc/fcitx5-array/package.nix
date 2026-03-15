{
  lib,
  stdenv,
  fetchFromGitHub,
  fmt,
  cmake,
  extra-cmake-modules,
  gettext,
  fcitx5,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-array";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "ray2501";
    repo = pname;
    rev = version;
    hash = "sha256-YDFT/CawFiPN3kXzHMpenCzWMJSA1dFUhVe22EDfnU8=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    fmt
    gettext
    sqlite
  ];

  buildInputs = [
    fcitx5
  ];

  meta = {
    description = "Array wrapper for Fcitx5";
    homepage = "https://github.com/ray2501/fcitx5-array";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ yanganto ];
    platforms = lib.platforms.linux;
  };
}
