{
  lib,
  stdenvNoCC,
  fetchzip,
}:
stdenvNoCC.mkDerivation {
  pname = "nsf-ordlista";
  version = "2025";
  src = fetchzip {
    url = "https://www2.scrabbleforbundet.no/wp-content/uploads/2025/09/nsf2025.zip";
    hash = "sha256-dqfHjD7F/lVR/n7NSzzYlLz3suE96JsUCPlpf/kCUew=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 nsf2025.txt $out/share/wordlists/nsf.txt
    runHook postInstall
  '';

  meta = {
    description = "Wordlist from the Norwegian Scrabble Federation";
    homepage = "https://www2.scrabbleforbundet.no/";
    downloadPage = "https://www2.scrabbleforbundet.no/?p=5127";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ h7x4 ];
    platforms = lib.platforms.all;
  };
}
