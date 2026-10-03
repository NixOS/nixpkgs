{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "faac";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faac";
    tag = "faac-${finalAttrs.version}";
    hash = "sha256-sy82jax3XrflPwwjCWpA19PIGek388PdkxKZgl/NURs=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonFlags = [
    "-Db_lto=false" # plugin needed to handle lto object
  ];

  enableParallelBuilding = true;

  meta = {
    changelog = "https://github.com/knik0/faac/releases/tag/${finalAttrs.src.tag}";
    description = "Open source MPEG-4 and MPEG-2 AAC encoder";
    homepage = "https://github.com/knik0/faac";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
