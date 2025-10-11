{
  lib,
  stdenv,
  fetchFromGitHub,
  llvmPackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bsc";
  version = "3.3.6";

  src = fetchFromGitHub {
    owner = "IlyaGrebnov";
    repo = "libbsc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iUFKTDSAg2/57TPvR0nlmfVN2Z6O9kZKIg+BQQKvr/o=";
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

  passthru.updateScript = nix-update-script {};

  meta = {
    description = "High performance block-sorting data compression library";
    homepage = "http://libbsc.com/";
    maintainers = with lib.maintainers; [ sigmanificient ];
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    mainProgram = "bsc";
  };
})
