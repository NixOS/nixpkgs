{
  stdenv,
  lib,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ks";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "loteoo";
    repo = "ks";
    rev = "${finalAttrs.version}";
    hash = "sha256-v05wqlG7Utq1b7ctvDY9MCdjHVVZZNNzuHaIBwuRjEE=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp ${finalAttrs.pname} $out/bin/
  '';

  meta = {
    mainProgram = "ks";
    homepage = "https://github.com/loteoo/ks";
    description = "Command-line secrets manager powered by macOS keychains";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ivankovnatsky ];
    platforms = lib.platforms.darwin;
  };
})
