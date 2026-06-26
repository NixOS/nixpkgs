{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "canboat";
  version = "6.2.2";

  src = fetchFromGitHub {
    owner = "canboat";
    repo = "canboat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ptuhp5cvMbfc2+RmdygzsegGwWgIgkgAk3NQ76j1pMw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    installShellFiles
  ];

  enableParallelBuilding = true;

  # Upstream ships no usable install rule; binaries land in rel/<uname>-<arch>/.
  installPhase = ''
    runHook preInstall
    installBin rel/*/*
    runHook postInstall
  '';

  meta = {
    description = "NMEA 2000/CAN analysis and conversion toolkit";
    homepage = "https://github.com/canboat/canboat";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.darkone ];
    mainProgram = "analyzer";
    platforms = lib.platforms.linux;
  };
})
