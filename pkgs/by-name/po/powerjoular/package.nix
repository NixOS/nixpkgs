{
  stdenv,
  lib,
  fetchFromGitHub,
  gnat,
  gprbuild,
}:

stdenv.mkDerivation rec {
  pname = "powerjoular";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "joular";
    repo = "powerjoular";
    rev = version;
    hash = "sha256-+LJwkm/3o8DIbbxxeyOIIK2XZNq8Pg5tAR2BI8lC04c=";
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

<<<<<<< HEAD
  meta = {
    description = "CLI software to monitor the power consumption of software and hardware components";
    homepage = "https://github.com/joular/powerjoular";
    maintainers = [ lib.maintainers.julienmalka ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "CLI software to monitor the power consumption of software and hardware components";
    homepage = "https://github.com/joular/powerjoular";
    maintainers = [ maintainers.julienmalka ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
