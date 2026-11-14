{
  lib,
  stdenv,
  fetchFromGitHub,
  imlib2,
  libx11,
}:

stdenv.mkDerivation {
  pname = "icat";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "atextor";
    repo = "icat";
    rev = "5d04cc2f14f81016b522865bc764f042db22ee81";
    hash = "sha256-aiLPVdKSppT/PWPW0Ue475WG61pBLh8OtLuk2/UU3nM=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  buildInputs = [
    imlib2
    libx11
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp icat $out/bin
    runHook postInstall
  '';

  meta = {
    description = "Outputs images in 256-color capable terminals";
    homepage = "https://github.com/atextor/icat";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ abhi-kr-2100 ];
    mainProgram = "icat";
    platforms = lib.platforms.linux;
  };
}
