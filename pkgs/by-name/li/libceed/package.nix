{
  lib,
  stdenv,
  fetchFromGitHub,
  fixDarwinDylibNames,
  python3,
  llvmPackages,
  withOpenmp ? false,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libceed";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "CEED";
    repo = "libCEED";
    tag = "v${finalAttrs.version}";
    hash = "sha256-757Ro/Y2HdA8XvA6zFfDUTTbYwD+WWvPIkhoVdPfPJ0=";
  };

  # makeFlags/checkFlags below contain values with spaces
  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = lib.optional (withOpenmp && stdenv.cc.isClang) llvmPackages.openmp;

  nativeInstallCheckInputs = [ python3 ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    # The default OPT adds -march=native / -mcpu=native; keep the build portable.
    "OPT=-O2 -g -ffp-contract=fast -fopenmp-simd"
    # Disable the Fortran interface/tests.
    "FC="
    # Built from a tarball, so `git describe` is unavailable.
    "GIT_DESCRIBE=${finalAttrs.src.tag}"
    # libCEED bakes the path to its JIT kernel sources into the library: the
    # source tree unless `install` is a make goal, $out/include if it is.
    # Force the installed path in every phase, so the library is built once
    # and the tests run against the copy that gets installed.
    "for_install=1"
  ]
  ++ lib.optional withOpenmp "OPENMP=1"
  ++ lib.optional stdenv.hostPlatform.isStatic "STATIC=1";

  enableParallelBuilding = true;

  # The baked-in JIT source root ($out/include) only exists after install.
  # Keep the headers in $out (no `dev` output), or that path breaks.
  doInstallCheck = true;
  installCheckTarget = "test";
  installCheckFlags = [
    # Core unit tests (t*) on the always-available CPU backends.
    "search=t"
    "BACKENDS=/cpu/self/ref/serial /cpu/self/ref/blocked /cpu/self/opt/serial /cpu/self/opt/blocked"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Code for Efficient Extensible Discretizations";
    longDescription = ''
      libCEED is a low-level API library for the efficient high-order
      discretization methods developed by the ECP co-design Center for
      Efficient Exascale Discretizations (CEED). It provides portable
      matrix-free operator evaluation on CPUs and GPUs.
    '';
    homepage = "https://libceed.org";
    changelog = "https://github.com/CEED/libCEED/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ grahamnorris ];
    platforms = lib.platforms.unix;
  };
})
