{
  stdenv,
  lib,
  fetchFromGitHub,
  gnat,
  gprbuild,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "powerjoular";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "joular";
    repo = "powerjoular";
    rev = finalAttrs.version;
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

  meta = {
    description = "CLI software to monitor the power consumption of software and hardware components";
    homepage = "https://github.com/joular/powerjoular";
    maintainers = [ lib.maintainers.julienmalka ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
  };
})
