{
  stdenv,
  lib,
  fetchFromGitHub,
  gnat,
  gprbuild,
}:

stdenv.mkDerivation rec {
  pname = "powerjoular";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "joular";
    repo = pname;
    rev = version;
    hash = "sha256-1XNXe5EZHB1kK2C5oyRt4TzfjZivW9DOEvS1MxJHC8E=";
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

  meta = with lib; {
    description = "CLI software to monitor the power consumption of software and hardware components";
    homepage = "https://github.com/joular/powerjoular";
    maintainers = [ maintainers.julienmalka ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
