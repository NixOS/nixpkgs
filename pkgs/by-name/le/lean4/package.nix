{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  git,
  gmp,
  cadical,
  pkg-config,
  libuv,
  enableMimalloc ? true,
  perl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lean4";
  version = "4.21.0";

  # Using a vendored version rather than nixpkgs' version to match the exact version required by
  # Lean.  Apparently, even a slight version change can impact greatly the final performance.
  mimalloc-src = fetchFromGitHub {
    owner = "microsoft";
    repo = "mimalloc";
    tag = "v2.2.3";
    hash = "sha256-B0gngv16WFLBtrtG5NqA2m5e95bYVcQraeITcOX9A74=";
  };

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IZSx7KmkLMEob8BmK/Bi4sS5nh78NHPQPJYgedv2+6Y=";
  };

  postPatch =
    let
      pattern = "\${LEAN_BINARY_DIR}/../mimalloc/src/mimalloc";
    in
    ''
      substituteInPlace src/CMakeLists.txt \
        --replace-fail 'set(GIT_SHA1 "")' 'set(GIT_SHA1 "${finalAttrs.src.tag}")'

      # Remove tests that fails in sandbox.
      # It expects `sourceRoot` to be a git repository.
      rm -rf src/lake/examples/git/
    ''
    + (lib.optionalString enableMimalloc ''
      substituteInPlace CMakeLists.txt \
        --replace-fail 'MIMALLOC-SRC' '${finalAttrs.mimalloc-src}'
      for file in stage0/src/CMakeLists.txt stage0/src/runtime/CMakeLists.txt src/CMakeLists.txt src/runtime/CMakeLists.txt; do
        substituteInPlace "$file" \
          --replace-fail '${pattern}' '${finalAttrs.mimalloc-src}'
      done
    '');

  preConfigure = ''
    patchShebangs stage0/src/bin/ src/bin/
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    gmp
    libuv
    cadical
  ];

  nativeCheckInputs = [
    git
    perl
  ];

  patches = [ ./mimalloc.patch ];

  cmakeFlags = [
    "-DUSE_GITHASH=OFF"
    "-DINSTALL_LICENSE=OFF"
    "-DUSE_MIMALLOC=${if enableMimalloc then "ON" else "OFF"}"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      version = "v${finalAttrs.version}";
    };
  };

  meta = with lib; {
    description = "Automatic and interactive theorem prover";
    homepage = "https://leanprover.github.io/";
    changelog = "https://github.com/leanprover/lean4/blob/${finalAttrs.src.tag}/RELEASES.md";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [
      danielbritten
      jthulhu
    ];
    mainProgram = "lean";
  };
})
