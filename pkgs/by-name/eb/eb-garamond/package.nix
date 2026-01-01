{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
<<<<<<< HEAD
  ttfautohint-nox,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
=======
  ttfautohint,
}:
stdenvNoCC.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "eb-garamond";
  version = "0.016";

  src = fetchFromGitHub {
    owner = "georgd";
    repo = "EB-Garamond";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
=======
    tag = "v${version}";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    hash = "sha256-ajieKhTeH6yv2qiE2xqnHFoMS65//4ZKiccAlC2PXGQ=";
  };

  nativeBuildInputs = [
    (python3.withPackages (p: [ p.fontforge ]))
<<<<<<< HEAD
    ttfautohint-nox
=======
    ttfautohint
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "@\$(SFNTTOOL) -w \$< \$@"   "@fontforge -lang=ff -c 'Open(\$\$1); Generate(\$\$2)' \$< \$@"
  '';

  buildPhase = ''
    runHook preBuild
    make WEB=build EOT="" all
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/*.ttf  -t $out/share/fonts/truetype
    install -Dm644 build/*.otf  -t $out/share/fonts/opentype
    install -Dm644 build/*.woff -t $out/share/fonts/woff

    runHook postInstall
  '';

<<<<<<< HEAD
  meta = {
    homepage = "http://www.georgduffner.at/ebgaramond/";
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    homepage = "http://www.georgduffner.at/ebgaramond/";
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      bengsparks
      relrod
      rycee
    ];
<<<<<<< HEAD
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
=======
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
