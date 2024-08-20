{ lib
, stdenv
, cmake
, fetchFromGitHub
, git
, gmp
, perl
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lean4";
  version = "4.9.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wi7outnKpz60to6Z7MSGAKK6COxmpJo6iu6Re86jqlo=";
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
  ];

  buildInputs = [
    gmp
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
    };
  };

  meta = with lib; {
    description = "Automatic and interactive theorem prover";
    homepage = "https://leanprover.github.io/";
    changelog = "https://github.com/leanprover/lean4/blob/${finalAttrs.src.rev}/RELEASES.md";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ danielbritten ];
    mainProgram = "lean";
  };
})
