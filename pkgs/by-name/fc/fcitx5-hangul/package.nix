{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  gettext,
  fcitx5,
  libhangul,
  nixosTests,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-hangul";
  version = "5.1.11";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = finalAttrs.pname;
    rev = finalAttrs.version;
    hash = "sha256-r1B4U51fYlHOgteDQyuYEUfZaEbRbENKmcYY5osj8UY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    libhangul
  ];

  passthru.tests = {
    inherit (nixosTests) fcitx5;
  };

  meta = {
    description = "Hangul wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-hangul";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ xrelkd ];
    platforms = lib.platforms.linux;
  };
})
