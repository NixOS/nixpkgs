{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "faac";
  version = "1.50";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faac";
    tag = "faac-${finalAttrs.version}";
    hash = "sha256-264+OHyqG5Ccwx15cHhDqsk+9Z6UsdYr0bvrPWHP5xw=";
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
    hasNoMaintainersButDependents = true;
  };
})
