{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bencodetools";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "heikkiorsila";
    repo = "bencodetools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FVDZUneArvKbCzn7X97BNh+7OJH3t86l7k7fv9ar5jk=";
  };

  postPatch = ''
    patchShebangs configure
  '';

  enableParallelBuilding = true;

  configureFlags = [ (lib.strings.withFeature false "python") ];

  # installCheck instead of check due to -install_name'd library on Darwin
  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  installCheckPhase = ''
    runHook preInstallCheck

    ./bencodetest

    runHook postInstallCheck
  '';

  passthru = {
    tests.python-module = python3Packages.bencodetools;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Collection of tools for manipulating bencoded data";
    homepage = "https://gitlab.com/heikkiorsila/bencodetools";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    mainProgram = "bencat";
    platforms = lib.platforms.unix;
  };
})
