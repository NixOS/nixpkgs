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
  version = "4.12.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    rev = "v${finalAttrs.version}";
    hash = "sha256-O2Egyh2D0TfQWzQKfHUeAh7qAjMfeLVwXwGUw5QqcvE=";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace 'set(GIT_SHA1 "")' 'set(GIT_SHA1 "${finalAttrs.src.rev}")'

    # Remove tests that fails in sandbox.
    # It expects `sourceRoot` to be a git repository.
    rm -rf src/lake/examples/git/
  '';

  preConfigure = ''
    patchShebangs stage0/src/bin/ src/bin/
  '';

  nativeBuildInputs = [
    cmake
    cadical
  ];

  buildInputs = [
    gmp
    libuv
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
    changelog = "https://github.com/leanprover/lean4/blob/${finalAttrs.src.rev}/RELEASES.md";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [
      danielbritten
      jthulhu
    ];
    mainProgram = "lean";
  };
})
