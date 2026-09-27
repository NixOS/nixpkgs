{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "octomap";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "OctoMap";
    repo = "octomap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GlYfAZGSMO8nMQxFyvFs+ZM8vBRMlnpfiIXe6kCUJa0=";
  };

  sourceRoot = "${finalAttrs.src.name}/octomap";

  nativeBuildInputs = [ cmake ];

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    changelog = "https://github.com/OctoMap/octomap/releases/tag/${finalAttrs.src.tag}";
    description = "Probabilistic, flexible, and compact 3D mapping library for robotic systems";
    homepage = "https://octomap.github.io/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      lopsided98
      nim65s
    ];
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
