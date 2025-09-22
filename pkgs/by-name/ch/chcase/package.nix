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
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "chcase";
    tag = finalAttrs.version;
    hash = "sha256-3TuAnuWV3Sm1T76Go4NWe2eA55ImR1TFYoCUnqfp9DE=";
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
    maintainers = with lib.maintainers; [ ];
  };
})
