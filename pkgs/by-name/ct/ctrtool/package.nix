{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ctrtool";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "jakcron";
    repo = "Project_CTR";
    rev = "ctrtool-v${finalAttrs.version}";
    sha256 = "GvEzv97DqCsaDWVqDpajQRWYe+WM8xCYmGE0D3UcSrM=";
  };

  sourceRoot = "${finalAttrs.src.name}/ctrtool";

  enableParallelBuilding = true;

  preBuild = ''
    make -j $NIX_BUILD_CORES deps
  '';

  # workaround for https://github.com/3DSGuy/Project_CTR/issues/145
  env.NIX_CFLAGS_COMPILE = "-O0";

  installPhase = "
    mkdir $out/bin -p
    cp bin/ctrtool${stdenv.hostPlatform.extensions.executable} $out/bin/
  ";

  passthru.updateScript = gitUpdater { rev-prefix = "ctrtool-v"; };

  meta = {
    license = lib.licenses.mit;
    description = "Tool to extract data from a 3ds rom";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ marius851000 ];
    mainProgram = "ctrtool";
  };

})
