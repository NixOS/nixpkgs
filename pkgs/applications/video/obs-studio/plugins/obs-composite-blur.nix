{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-composite-blur";
  version = "1.6.1";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "FiniteSingularity";
    repo = "obs-composite-blur";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HV3oEVpEwQqbx7xyExJEY14hgqnWjwQvg4Zy11RNFF0=";
  };

  buildInputs = [
    obs-studio
  ];

  nativeBuildInputs = [
    cmake
  ];

  meta = {
    description = "Comprehensive blur plugin for OBS that provides several different blur algorithms, and proper compositing";
    homepage = "https://github.com/FiniteSingularity/obs-composite-blur";
    changelog = "https://github.com/FiniteSingularity/obs-composite-blur/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    platforms = lib.platforms.linux;
  };
})
