{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "qrcode";
  version = "0-unstable-2025-04-29";

  src = fetchFromGitHub {
    owner = "qsantos";
    repo = "qrcode";
    rev = "29140c67b69b79e5c8a52911489648853fddf85f";
    hash = "sha256-WQeZB8G9Nm68mYmLr0ksZdFDcQxF54X0yJxigJZWvMo=";
  };

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  installPhase = ''
    mkdir -p "$out"/{bin,share/doc/qrcode}
    cp qrcode "$out/bin"
    cp DOCUMENTATION LICENCE "$out/share/doc/qrcode"
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Small QR-code tool";
    homepage = "https://github.com/qsantos/qrcode";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      raskin
      lucasew
    ];
    platforms = with lib.platforms; unix;
    mainProgram = "qrcode";
  };
}
