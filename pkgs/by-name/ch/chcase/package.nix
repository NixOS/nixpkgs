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
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "ryonakano";
    repo = "chcase";
    tag = finalAttrs.version;
    hash = "sha256-+aTBrsmoGw8ezYZbvYQblkiwExOKKWBi25zKEmhAAsU=";
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
