{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  blueprint-compiler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "chcase";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "chcase";
    tag = finalAttrs.version;
    hash = "sha256-nvvfmw4tM3LuBAg503wu+EPg6iOLgd5XJ/ncdonbGnA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    blueprint-compiler
  ];

  meta = {
    homepage = "https://github.com/ryonakano/chcase";
    description = "Small library to convert case of a given string";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
