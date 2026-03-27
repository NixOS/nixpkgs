{
  lib,
  stdenv,
  fetchzip,
}:

let
  font = "kanji-stroke-order";
in
stdenv.mkDerivation {
  pname = "${font}-font";
  version = "4.005";

  src = fetchzip {
    # https://github.com/NixOS/nixpkgs/issues/60157
    url = "https://drive.google.com/uc?export=download&id=1DKZEYA3PJ8ulLnjYDP5bxzJ3SWi59ghr#${font}.zip";
    hash = "sha256-6mw72eoRIGzG2IoVnPo1G0i2Z2Ot8Q/WjaJ8tNDQbMk=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/${font}
    install -Dm644 *.txt -t $out/share/doc/${font}
    install -Dm644 *.pdf -t $out/share/doc/${font}

    runHook postInstall
  '';

  meta = {
    description = "Font containing stroke order diagrams for over 6500 kanji, 180 kana and other characters";
    homepage = "https://www.kanji.uk/";

    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [
      ptrhlm
      stephen-huan
    ];
    platforms = lib.platforms.all;
  };
}
