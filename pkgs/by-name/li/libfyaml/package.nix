{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  autoreconfHook,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfyaml";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "pantoniou";
    repo = "libfyaml";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mRQQe+J5wtLt/bI/Wer9TVGdU3a1zp3zFCm4oNQON8M=";
  };

  # backport 32-bit build fixes
  patches = [
    (fetchpatch {
      url = "https://github.com/pantoniou/libfyaml/commit/0982fcefc6a16d4c8cb5b06747d3fc8e630de3ae.diff";
      hash = "sha256-aDubIn+et+1fWE7XU7a5AGZVacVFbAbC1PoSDrA6hXw=";
    })
    (fetchpatch {
      url = "https://github.com/pantoniou/libfyaml/commit/9192deaac095f9881cc1e5756dede683f36b09d6.diff";
      hash = "sha256-cNL9wQtxIRg/ShZLJP4qHYNFRrYo9kRG+/U+3FiUeaI=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
  ];

  configureFlags = [ "--disable-network" ];

  doCheck = true;

  preCheck = ''
    patchShebangs test
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Autoconf's thread probe can leak the literal "none required" marker
    # into libfyaml.pc on Darwin, which then breaks downstream link steps.
    substituteInPlace "$dev/lib/pkgconfig/libfyaml.pc" \
      --replace-fail " none required" ""
  '';

  passthru.tests.pkg-config = testers.hasPkgConfigModules {
    package = finalAttrs.finalPackage;
  };

  meta = {
    description = "Fully feature complete YAML parser and emitter, supporting the latest YAML spec and passing the full YAML testsuite";
    homepage = "https://github.com/pantoniou/libfyaml";
    changelog = "https://github.com/pantoniou/libfyaml/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ilkecan ];
    pkgConfigModules = [ "libfyaml" ];
    platforms = lib.platforms.all;
  };
})
