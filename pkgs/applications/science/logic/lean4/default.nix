{ lib
, stdenv
, cmake
, fetchFromGitHub
, git
, gmp
, perl
}:

stdenv.mkDerivation rec {
  pname = "lean4";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "leanprover";
    repo = "lean4";
    rev = "v${version}";
    hash = "sha256-6qbCafG0bL5KxQt2gL6hV4PFDsEMM0UXfldeOOqxsaE=";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace 'set(GIT_SHA1 "")' 'set(GIT_SHA1 "${src.rev}")'

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
  ];

  meta = with lib; {
    description = "Automatic and interactive theorem prover";
    homepage = "https://leanprover.github.io/";
    changelog = "https://github.com/leanprover/lean4/blob/${src.rev}/RELEASES.md";
    license = licenses.asl20;
    platforms = platforms.all;
    maintainers = with maintainers; [ marsam ];
    mainProgram = "lean";
  };
}
