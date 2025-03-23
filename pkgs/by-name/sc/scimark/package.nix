{
  lib,
  stdenv,
  fetchurl,
  unzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "scimark";
  version = "4c";

  src = fetchurl {
    url = "https://math.nist.gov/scimark2/scimark${finalAttrs.version}.zip";
    hash = "sha256-kcg5vKYp0B7+bC/CmFMO/tMwxf9q6nvuFv0vRSy3MbE=";
  };

  nativeBuildInputs = [
    unzip
  ];

  dontConfigure = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 scimark4 -t $out/bin/

    runHook postInstall
  '';

  meta = {
    homepage = "https://math.nist.gov/scimark2/index.html";
    description = "Scientific and numerical computing benchmark (ANSI C version)";
    downloadPage = "https://math.nist.gov/scimark2/download_c.html";
    license = lib.licenses.publicDomain;
    mainProgram = "scimark4";
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.all;
  };
})
