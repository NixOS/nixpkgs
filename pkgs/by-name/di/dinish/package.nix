{
  lib,
  stdenvNoCC,
  fetchzip,
  nix-update-script,
}:

stdenvNoCC.mkDerivation rec {
  pname = "dinish";
  version = "4.007";

  src = fetchzip {
    url = "https://github.com/playbeing/dinish/releases/download/v${version}/dinish-ttf.zip";
    stripRoot = false;
    hash = "sha256-u/AYA9/8piZ6hz4XD3uSruOM0deeXQ5Gb0N/8rlDiP0=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/playbeing/dinish";
    changelog = "https://github.com/playbeing/dinish/blob/v${version}/FONTLOG.txt";
    description = "Modern computer font inspired by DIN 1451";
    longDescription = "DINish is one of many modern computer fonts that were inspired by the lettering of the German Autobahn road signs. It is professionally designed, and usable for body text and captions, even spreadsheets. Its unadorned style is easy to read, and although it is close to a century old maintains a fresh look.";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ vji ];
  };
}
