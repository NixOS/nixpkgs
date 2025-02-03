{
  lib,
  stdenvNoCC,
  fetchurl,
  autoPatchelfHook,
  curl,
  gfortran,
  zlib,
}:

stdenvNoCC.mkDerivation {
  pname = "paup";
  version = "4.0a168";

  src = fetchurl {
    url = "http://phylosolutions.com/paup-test/paup4a168_centos64.gz";
    hash = "sha256-41dZswlrIQ05f1zJzId78DKmPf0QH1SfrexzvCAUxq8=";
  };

  unpackPhase = ''
    runHook preUnpack

    gunzip -c $src > paup

    runHook postUnpack
  '';

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    curl
    gfortran
    zlib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 paup -t $out/bin

    runHook postInstall
  '';

  meta = {
    description = "A software package for inferring evolutionary trees";
    homepage = "http://phylosolutions.com/paup-test/";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "paup";
    platforms = [ "x86_64-linux" ];
  };
}
