{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bsc";
  version = "3.3.4";

  src = fetchFromGitHub {
    owner = "IlyaGrebnov";
    repo = "libbsc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-reGg5xvoZBbNFFYPPyT2P1LA7oSCUIm9NIDjXyvkP9Q=";
  };

  enableParallelBuilding = true;

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin llvmPackages.openmp;

  postPatch = lib.optional (!stdenv.hostPlatform.isx86) ''
    substituteInPlace makefile \
      --replace-fail "-mavx2" ""

    substituteInPlace makefile.cuda \
      --replace-fail "-mavx2" ""
  '';

  makeFlags = [
    "CC=$(CXX)"
    "PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "High performance block-sorting data compression library";
    homepage = "http://libbsc.com/";
    maintainers = with maintainers; [ sigmanificient ];
    license = licenses.asl20;
    platforms = platforms.unix;
    mainProgram = "bsc";
  };
})
