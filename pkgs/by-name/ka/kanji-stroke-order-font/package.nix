{
  lib,
  stdenv,
  fetchzip,
}:

let
  font = "kanji-stroke-order";
  version = "4.004";
in
stdenv.mkDerivation {
  pname = "${font}-font";
  inherit version;

  src = fetchzip {
    # https://github.com/NixOS/nixpkgs/issues/60157
    url = "https://drive.google.com/uc?export=download&id=1snpD-IQmT6fGGQjEePHdDzE2aiwuKrz4#${font}.zip";
    hash = "sha256-wQpurDS6APnpNMbMHofwW/UKeBF8FXeiCVx4wAOeRoE=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/${font}
    install -Dm644 *.txt -t $out/share/doc/${font}
    install -Dm644 *.pdf -t $out/share/doc/${font}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Font containing stroke order diagrams for over 6500 kanji, 180 kana and other characters";
    homepage = "https://www.nihilist.org.uk/";

    license = [ licenses.bsd3 ];
    maintainers = with maintainers; [
      ptrhlm
      stephen-huan
    ];
    platforms = platforms.all;
  };
}
