{ lib, stdenv, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "qrcode";
  version = "0-unstable-2024-06-05";

  src = fetchFromGitHub {
    owner = "qsantos";
    repo = "qrcode";
    rev = "822923d1b088c58e329c155baa5e5f3e83021947";
    hash = "sha256-e/HnMOcfpGaQkPdp9zww08G4Rc1z0flA2Ghu57kKsQA=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/qrcode}
    cp qrcode "$out/bin"
    cp DOCUMENTATION LICENCE "$out/share/doc/qrcode"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Small QR-code tool";
    homepage = "https://github.com/qsantos/qrcode";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ raskin lucasew ];
    platforms = with platforms; unix;
    mainProgram = "qrcode";
  };
}
