{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  obs-studio,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-composite-blur";
  version = "1.5.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-composite-blur";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wT49bCxik8mrg+YleNelOPQQzqcYQR7ZSnzvPXA5D3g=";
  };

  patches = [
    # Fix build with glibc >= 2.43 (C23 const-preserving strrchr):
    # https://github.com/FiniteSingularity/obs-composite-blur/pull/138
    (fetchpatch {
      name = "fix-strrchr-discarded-qualifiers.patch";
      url = "https://github.com/FiniteSingularity/obs-composite-blur/commit/4773875d2ac1335f752b31ca4fb16229bff1a4aa.patch";
      hash = "sha256-V9Mt48a4dALX3t4nXz45tNtKrlEgznjdyPeXYPMpGno=";
    })
  ];

  buildInputs = [
    obs-studio
  ];

  nativeBuildInputs = [
    cmake
  ];

  postInstall = ''
    rm -rf "$out/share"
    mkdir -p "$out/share/obs"
    mv "$out/data/obs-plugins" "$out/share/obs"
    rm -rf "$out/obs-plugins" "$out/data"
  '';

  meta = {
    description = "Comprehensive blur plugin for OBS that provides several different blur algorithms, and proper compositing";
    homepage = "https://github.com/FiniteSingularity/obs-composite-blur";
    changelog = "https://github.com/FiniteSingularity/obs-composite-blur/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
