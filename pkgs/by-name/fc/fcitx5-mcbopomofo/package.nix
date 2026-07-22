{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  gettext,
  json_c,
  icu,
  fmt,
  gtest,
  fcitx5,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-mcbopomofo";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "openvanilla";
    repo = "fcitx5-mcbopomofo";
    rev = finalAttrs.version;
    hash = "sha256-yeqNiRiV/RXyFAlEfvsTLcw+AD/qZNvPLr34Cvqe360=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    gettext
  ];

  buildInputs = [
    kdePackages.extra-cmake-modules
    fcitx5
    fmt
    gtest
    icu
    json_c
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "McBopomofo for fcitx5";
    homepage = "https://github.com/openvanilla/fcitx5-mcbopomofo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shiphan ];
    platforms = lib.platforms.linux;
  };
})
