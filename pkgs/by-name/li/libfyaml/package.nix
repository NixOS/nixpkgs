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

  patches = [
    (fetchpatch {
      name = "musl.patch";
      url = "https://github.com/pantoniou/libfyaml/compare/a92caa88b0b0fe61296325a25fed99a91d77bb6c...9f2492ca27bb1fda64f2b12edc2da17406208b93.patch";
      hash = "sha256-hIwVwyHci4SeZ9PR/Z6Sf+cS0lP7COpQ3DVua6ll9+o=";
    })

    # backport 32-bit build fixes
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
