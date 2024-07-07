{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "sn-pro";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "supernotes";
    repo = "sn-pro";
    rev = version;
    hash = "sha256-G/DIHWs91HYVbrV/jZ4aFsCCjqORo8YeqcHGN0LZ8p4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/otf exports/SNPro/*.otf
    install -Dm644 -t $out/share/fonts/woff2 exports/SNPro/*.woff2

    runHook postInstall
  '';

  meta = with lib; {
    description = "SN Pro Font Family";
    homepage = "https://github.com/supernotes/sn-pro";
    license = licenses.ofl;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.all;
  };
}
