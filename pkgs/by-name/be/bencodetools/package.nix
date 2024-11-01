{
  stdenv,
  lib,
  fetchFromGitLab,
}:

stdenv.mkDerivation {
  pname = "bencodetools";
  version = "unstable-2022-05-11";

  src = fetchFromGitLab {
    owner = "heikkiorsila";
    repo = "bencodetools";
    rev = "384d78d297a561dddbbd0f4632f0c74c0db41577";
    hash = "sha256-FQ+U4cya3CfUb4BVpqtOrrFKSlciwTVxrROOkRNOybQ=";
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

  meta = {
    description = "Collection of tools for manipulating bencoded data";
    homepage = "https://gitlab.com/heikkiorsila/bencodetools";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    mainProgram = "bencat";
    platforms = lib.platforms.unix;
  };
}
