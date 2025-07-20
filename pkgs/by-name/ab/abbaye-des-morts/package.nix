{
  lib,
  stdenv,
  fetchFromGitHub,
  SDL2,
  SDL2_image,
  SDL2_mixer,
}:

stdenv.mkDerivation rec {
  pname = "abbaye-des-morts";
  version = "2.0.5";

  src = fetchFromGitHub {
    owner = "nevat";
    repo = "abbayedesmorts-gpl";
    tag = "v${version}";
    sha256 = "sha256-muJt1cml0nYdgl0v8cudpUXcdSntc49e6zICTCwzkks=";
  };

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "DESTDIR="
  ];

  preBuild = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace Makefile \
      --replace -fpredictive-commoning ""
  '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/applications
  '';

  meta = {
    homepage = "https://locomalito.com/abbaye_des_morts.php";
    description = "Retro arcade video game";
    mainProgram = "abbayev2";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marius851000 ];
  };
}
