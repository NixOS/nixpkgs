{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opus";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "xiph";
    repo = "opus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M1G7ypcfs7nJmXgkyoG96jT/CkgN5BOzy+DGO4LVCvA=";
  };

  __structuredAttrs = true;

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    meson
    ninja
  ];

  meta = {
    description = "Modern audio compression for the internet";
    homepage = "https://github.com/xiph/opus";
    changelog = "https://github.com/xiph/opus/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "opus";
    platforms = lib.platforms.all;
  };
})
