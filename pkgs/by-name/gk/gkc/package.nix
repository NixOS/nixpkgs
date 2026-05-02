{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
}:
stdenv.mkDerivation {
  pname = "gkc";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "tammet";
    repo = "gkc";
    tag = "v0.6.0";
    hash = "sha256-1hVE2IrUSDrpE1en+NPU4YCncBSqqS+fTz58r+P7wAE=";
  };

  nativeBuildInputs = [
    bison
    flex
  ];

  env.NIX_CFLAGS_COMPILE = "-fcommon";

  postPatch = ''
    substituteInPlace makefile --replace-fail "-static" ""
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp gkc $out/bin
    runHook postInstall
  '';

  meta = {
    description = "A reasoning system for large knowledge bases";
    homepage = "https://github.com/tammet/gkc";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.thngz ];
    platforms = lib.platforms.unix;
    mainProgram = "gkc";
  };
}
