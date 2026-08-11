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
    # backport "Fix C11 atomics detection and buggy macros for C++ compatibility"
    (fetchpatch {
      url = "https://github.com/pantoniou/libfyaml/commit/1026d76850909dc9b1c5f95b8cd94e865a313fd5.diff";
      hash = "sha256-0YfOqdqHdELFMqr52TDAC3BNFLkcuxvuJY5b9yZ7NFk=";
    })
    (fetchpatch {
      url = "https://github.com/pantoniou/libfyaml/commit/9192deaac095f9881cc1e5756dede683f36b09d6.diff";
      hash = "sha256-cNL9wQtxIRg/ShZLJP4qHYNFRrYo9kRG+/U+3FiUeaI=";
    })
    # On Darwin, AX_PTHREAD returns empty PTHREAD_LIBS with -pthread in PTHREAD_CFLAGS;
    # don't force -lpthread when PTHREAD_CFLAGS already provides pthread support.
    # Pending PR: https://github.com/pantoniou/libfyaml/pull/294
    ./pthread-darwin.patch

    # backport "build: don't output 'none required' to LIBM if no linker flags needed for it"
    (fetchpatch {
      url = "https://github.com/pantoniou/libfyaml/commit/24b18e7363b336962fe160c1dc05ca57ba95783c.diff";
      hash = "sha256-g5QKI4HuS8MEQ9ddIQNC0j+28Dh9zLAp5RaZX5SWBHk=";
    })
    (fetchpatch {
      url = "https://github.com/pantoniou/libfyaml/commit/9f2492ca27bb1fda64f2b12edc2da17406208b93.diff";
      hash = "sha256-E4wS+P7R3VGrBpD7swWMMi/QPTF+9rzAeEyxhbmdiwk=";
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
