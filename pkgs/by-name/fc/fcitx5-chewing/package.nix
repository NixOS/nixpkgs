{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  gettext,
  fcitx5,
  libchewing,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-chewing";
  version = "5.1.13";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-cHiHu1mO9Ph3TDGArWfvmm0/4+CeJf5Z/EUDg7Qi0X8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    libchewing
  ];

  meta = {
    description = "Chewing wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-chewing";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ xrelkd ];
    platforms = lib.platforms.linux;
  };
}
