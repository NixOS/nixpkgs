{ lib, stdenvNoCC, fetchurl }:

stdenvNoCC.mkDerivation rec {
  pname = "oldsindhi";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/MihailJP/${pname}/releases/download/v${version}/OldSindhi-${version}.tar.xz";
    hash = "sha256-jOcl+mo6CJ9Lnn3nAUiXXHCJssovVgLoPrbGxj4uzQs=";
  };

  installPhase = ''
    runHook preInstall

    install -m444 -Dt $out/share/fonts/truetype *.ttf
    install -m444 -Dt $out/share/doc/${pname}-${version} README *.txt

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/MihailJP/oldsindhi";
    description = "Free Sindhi Khudabadi font";
    maintainers = with maintainers; [ mathnerd314 ];
    license = with licenses; [ mit ofl ];
    platforms = platforms.all;
  };
}
