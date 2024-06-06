{ lib, stdenvNoCC, fetchgit }:

stdenvNoCC.mkDerivation (final: {
  pname = "cormorant";
  version = "3.609";

  src = fetchgit {
    url = "https://github.com/CatharsisFonts/Cormorant.git";
    rev = "v${final.version}";
    hash = "sha256-W63N1d4NWh7JMHbdQKAjYpzcnMDSz6qkiajLRWYXVzo=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/opentype $out/share/fonts/truetype
    install -Dt $out/share/fonts/truetype $src/"1. TrueType Font Files"/*.ttf
    install -Dt $out/share/fonts/opentype $src/"2. OpenType Files"/*.otf

    runHook postInstall
  '';

  meta = with lib; {
    description = "A free display type family developed by Christian Thalmann";
    homepage = "https://github.com/CatharsisFonts/Cormorant";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ usertam ];
  };
})
