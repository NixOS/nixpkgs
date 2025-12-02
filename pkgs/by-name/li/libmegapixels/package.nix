{
  fetchFromGitLab,
  lib,
  libconfig,
  meson,
  ninja,
  pkg-config,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libmegapixels";
  version = "0.2.3";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitLab {
    owner = "megapixels-org";
    repo = "libmegapixels";
    tag = finalAttrs.version;
    hash = "sha256-YYZmjFLAswat++ojUaoYcJk+ruxT3qiuuLWfck23N1c=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libconfig
  ];

  doCheck = true;

  meta = {
    changelog = "https://gitlab.com/megapixels-org/libmegapixels/-/tags/${finalAttrs.src.tag}";
    description = "Device abstraction for the Megapixels camera application";
    homepage = "https://gitlab.com/megapixels-org/libmegapixels";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.dotlambda ];
    platforms = lib.platforms.linux;
  };
})
