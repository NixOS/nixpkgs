{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "faac";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "knik0";
    repo = "faac";
    tag = "faac-${finalAttrs.version}";
    hash = "sha256-+t8NNPaNlGXeDylEeBupOe5fbI1BD7JKDzdCRxRu52c=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  mesonFlags = [
    "-Db_lto=false" # plugin needed to handle lto object
  ];

  enableParallelBuilding = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/knik0/faac/releases/tag/${finalAttrs.src.tag}";
    description = "Open source MPEG-4 and MPEG-2 AAC encoder";
    homepage = "https://github.com/knik0/faac";
    license = lib.licenses.unfreeRedistributable;
    maintainers = with lib.maintainers; [ tmarkus ];
    platforms = lib.platforms.all;
  };
})
