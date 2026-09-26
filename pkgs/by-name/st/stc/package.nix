{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  flex,
  meson,
  ninja,
  pkg-config,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "stc";
  version = "5.0";

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "stclib";
    repo = "STC";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JiFyJN+hAbzTHqim1i6TJFmKfHlnOfP3yDLCZDE7uqo=";
  };

  patches = [
    # Backport pkg-config support and follow-up fixes from upstream.
    (fetchpatch {
      url = "https://github.com/stclib/STC/commit/92751b4d04b2d980d640b28bd22a9cd651d77c6a.patch";
      hash = "sha256-11sE5pS7sqdfCGsGlvajkfgCf+QIkRFp4Js2//kAI3s=";
    })
    (fetchpatch {
      url = "https://github.com/stclib/STC/commit/0fa9ad03516ba0f71b38674f0ec631929368f385.patch";
      hash = "sha256-e1rhrKaf9fFAmSi8Puo494iG+hAdHZFzyn8IJoKjdAI=";
    })
  ];

  postPatch = ''
    meson rewrite kwargs set project / version '${finalAttrs.version}'
  '';

  nativeBuildInputs = [
    flex
    meson
    ninja
    pkg-config
    validatePkgConfig
  ];

  doCheck = true;

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
    versionCheck = true;
  };

  meta = {
    description = "C99 container library with generic and type-safe data structures";
    homepage = "https://github.com/stclib/STC";
    changelog = "https://github.com/stclib/STC/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
    pkgConfigModules = [ "stc" ];
  };
})
