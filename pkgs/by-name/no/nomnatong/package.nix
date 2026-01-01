{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "nomnatong";
<<<<<<< HEAD
  version = "5.16";
=======
  version = "5.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "nomfoundation";
    repo = "font";
    rev = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-/VjnNZKHEXOOzDjic1tZufYS49rVDXcIl7eDj7jl7Vo=";
=======
    hash = "sha256-QVg54EX2ctfADe5976PHHId3r35oQEPDejvGU89+QeU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
    homepage = "https://nomfoundation.org/nom-tools/Nom-Font";
    description = "Hán-Nôm Coded Character Set and Nom Na Tong Regular Reference Font";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
