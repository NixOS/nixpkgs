{
  lib,
  stdenv,
  fetchFromGitHub,
  bison,
  flex,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gkc";
  version = "0.6.0";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "tammet";
    repo = "gkc";
    tag = "v${finalAttrs.version}";
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
    description = "A reasoning system for large knowledge bases. ";
    homepage = "https://github.com/tammet/gkc";
    license = lib.licenses.agpl3Only;
    maintainers = [ lib.maintainers.thngz ];
    platforms = lib.platforms.unix;
    mainProgram = "gkc";
  };
})
