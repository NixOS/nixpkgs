{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libGL,
  libx11,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gliden64";
  version = "0-unstable-2026-01-25";

  src = fetchFromGitHub {
    owner = "gonetz";
    repo = "GLideN64";
    rev = "c8ef81c7d9aede9f67f6ed3d3426c90541f9f13e";
    hash = "sha256-UQ2sS45sj2v45EZpOtsKXperE8Nf//qtYTYceGaqT5k=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libGL
    libx11
  ];

  cmakeFlags = [
    (lib.cmakeBool "MUPENPLUSAPI" true)
    (lib.cmakeBool "NO_OSD" true)
    (lib.cmakeBool "NOHQ" true)
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "New generation, open-source graphics plugin for N64 emulators";
    homepage = "https://github.com/gonetz/GLideN64";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ chuangzhu ];
    platforms = lib.platforms.unix;
  };
})
