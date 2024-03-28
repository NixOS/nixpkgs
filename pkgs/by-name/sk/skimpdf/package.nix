{ stdenv
, lib
, undmg
, fetchurl
}:
stdenv.mkDerivation rec {
  pname = "Skim";
  version = "1.6.21";

  src = fetchurl {
    name = "Skim-${version}.dmg";
    url = "mirror://sourceforge/project/skim-app/Skim/Skim-${version}/Skim-${version}.dmg";
    sha256 = "0SeS41ExCZfGmjiK2KvvdFpP7IVzm7xHKCaKmEUYQAY=";
  };

  nativeBuildInputs = [ undmg ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R Skim.app $out/Applications
    runHook postInstall
  '';

  meta = with lib; {
    description = "Skim is a PDF reader and note-taker for OS X";
    homepage = "https://skim-app.sourceforge.io/";
    license = licenses.bsd0;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "Skim.app";
    maintainers = with maintainers; [ YvesStraten ];
    platforms = platforms.darwin;
  };
}
