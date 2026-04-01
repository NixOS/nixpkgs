{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation {
  pname = "obj-magic";
  version = "0.5-unstable-2020-09-20";

  src = fetchFromGitHub {
    owner = "tapio";
    repo = "obj-magic";
    rev = "f25c9b78cee6529a3295ed314d1c200677dc56c0";
    hash = "sha256-4A8TasyLOh6oz21/AwBbE5s3055EPftFh8mymrveTvY=";
  };

  buildPhase = ''
    runHook preBuild
    ./make.sh
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D obj-magic $out/bin/obj-magic
    runHook postInstall
  '';

  meta = {
    description = "Command line tool for manipulating Wavefront OBJ 3D meshes";
    homepage = "https://github.com/tapio/obj-magic";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ lorenz ];
    platforms = lib.platforms.unix;
    mainProgram = "obj-magic";
  };
}
