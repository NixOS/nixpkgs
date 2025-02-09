{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "dinish";
  version = "4.005";

  src = fetchzip {
    url = "https://github.com/playbeing/dinish/releases/download/v${version}/dinish-ttf.zip";
    stripRoot = false;
    hash = "sha256-K4JzqzlxOpy4rIF9kdrQlCIyrykDhnF1p1Q8CDMWBqg=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    homepage = "https://github.com/playbeing/dinish";
    changelog = "https://github.com/playbeing/dinish/blob/v${version}/FONTLOG.txt";
    description = "Modern computer font inspired by DIN 1451";
    longDescription = "DINish is one of many modern computer fonts that were inspired by the lettering of the German Autobahn road signs. It is professionally designed, and usable for body text and captions, even spreadsheets. Its unadorned style is easy to read, and although it is close to a century old maintains a fresh look.";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ vji ];
  };
}
