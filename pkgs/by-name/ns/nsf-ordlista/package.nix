{ lib
, stdenvNoCC
, fetchzip
}:
stdenvNoCC.mkDerivation {
  pname = "nsf-ordlista";
  version = "unstable-2023-08-20";
  src = fetchzip {
    url = "http://www2.scrabbleforbundet.no/wp-content/uploads/2023/08/nsf2023.zip";
    hash = "sha256-bcVqZ2yPHurl6sRNgeLNAyyR8WR9ewmtn85Xuw/rZ3s=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm444 nsf2023.txt $out/share/wordlists/nsf.txt
    runHook postInstall
  '';

  meta = with lib; {
    description = "Wordlist from the Norwegian Scrabble Federation";
    homepage = "https://www2.scrabbleforbundet.no/";
    downloadPage = "https://www2.scrabbleforbundet.no/?p=4881#more-4881";
    license = licenses.unfree;
    maintainers = with maintainers; [ h7x4 ];
    platforms = platforms.all;
  };
}
