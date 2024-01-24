{ lib
, stdenvNoCC
, fetchFromGitHub
, python3Packages
, nix-update-script
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nomnatong";
  version = "5.08";

  src = fetchFromGitHub {
    owner = "nomfoundation";
    repo = "font";
    rev = "v${finalAttrs.version}";
    hash = "sha256-WtAxnTFrgXdG2T1vqfRc31tNKbZagDSO9lycKxn8dKg=";
  };

  nativeBuildInputs = [
    python3Packages.afdko
    python3Packages.fonttools
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  buildPhase = ''
    runHook preBuild

    makeotf -r -f font.pfa -omitMacNames -ff features.txt -mf FontMenuNameDB -ga -ci UnicodeVariationSequences.txt
    otf2ttf NomNaTong-Regular.otf
    sfntedit -d DSIG NomNaTong-Regular.otf

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 NomNaTong-Regular.otf -t $out/share/fonts/opentype/
    install -Dm444 NomNaTong-Regular.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "http://nomfoundation.org/nom-tools/Nom-Font";
    description = "The Hán-Nôm Coded Character Set and Nom Na Tong Regular Reference Font";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eclairevoyant ];
    platforms = lib.platforms.all;
  };
})
