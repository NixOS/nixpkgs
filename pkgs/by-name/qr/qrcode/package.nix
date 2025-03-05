{ lib, stdenv, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation {
  pname = "qrcode";
  version = "0-unstable-2024-07-18";

  src = fetchFromGitHub {
    owner = "qsantos";
    repo = "qrcode";
    rev = "6e882a26a30ab9478ba98591ecc547614fb62b69";
    hash = "sha256-wJL+XyYnI8crKVu+xwCioD5YcFjE5a92qkbOB7juw+s=";
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
