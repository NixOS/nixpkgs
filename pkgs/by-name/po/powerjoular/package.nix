{
  stdenv,
  lib,
  fetchFromGitHub,
  gnat,
  gprbuild,
}:

stdenv.mkDerivation rec {
  pname = "powerjoular";
  version = "1.0.5";

  src = fetchFromGitHub {
    owner = "joular";
    repo = pname;
    rev = version;
    hash = "sha256-rM6fV2Jw9C1LjMQ1RhV8DJQcUcyQmXtANXWAkO03O18=";
  };

  nativeBuildInputs = [
    gnat
    gprbuild
  ];

  buildPhase = ''
    runHook preBuild
    gprbuild
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp obj/powerjoular $out/bin
    runHook postInstall
  '';

  meta = {
    description = "CLI software to monitor the power consumption of software and hardware components";
    homepage = "https://github.com/joular/powerjoular";
    maintainers = [ lib.maintainers.julienmalka ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
}
