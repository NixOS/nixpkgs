{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  git,
  gmp,
  cadical,
  libuv,
  perl,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lean4";
  version = "4.16.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RdFTxLk0Yahwhu/oQeTappvWnUtnim63dxN7gmU8Jt8=";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'set(GIT_SHA1 "")' 'set(GIT_SHA1 "${finalAttrs.src.tag}")'

    # Remove tests that fails in sandbox.
    # It expects `sourceRoot` to be a git repository.
    rm -rf src/lake/examples/git/
  '';

  preConfigure = ''
    patchShebangs stage0/src/bin/ src/bin/
  '';

  nativeBuildInputs = [
    cmake
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

  cmakeFlags = [
    "-DUSE_GITHASH=OFF"
    "-DINSTALL_LICENSE=OFF"
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
