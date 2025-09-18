{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  gettext,
  json_c,
  icu,
  fmt,
  gtest,
  fcitx5,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-mcbopomofo";
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "openvanilla";
    repo = "fcitx5-mcbopomofo";
    rev = version;
    hash = "sha256-2TWJsEScC5rMz5dowJOQHA2Mjzsq+d9n2lKXdEWiELU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
  ];

  buildInputs = [
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
}
