{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  fcitx5,
  lua5_3,
  gettext,
}:

let
  lua = lua5_3;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "fcitx5-lua";
  version = "5.0.18";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-lua";
    tag = finalAttrs.version;
    hash = "sha256-YelfFE9RNQbsZm81TauleQxyiR3qOquLRHpQa9kyqEU=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    lua
  ];

  passthru = {
    extraLdLibraries = [ lua ];
  };

  meta = {
    description = "Lua support for Fcitx 5";
    homepage = "https://github.com/fcitx/fcitx5-lua";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
  };
})
