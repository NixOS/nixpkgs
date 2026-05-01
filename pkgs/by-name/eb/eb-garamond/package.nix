{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  ttfautohint-nox,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "eb-garamond";
  version = "0.016";

  src = fetchFromGitHub {
    owner = "georgd";
    repo = "EB-Garamond";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ajieKhTeH6yv2qiE2xqnHFoMS65//4ZKiccAlC2PXGQ=";
  };

  nativeBuildInputs = [
    (python3.withPackages (p: [ p.fontforge ]))
    ttfautohint-nox
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

  meta = {
    homepage = "http://www.georgduffner.at/ebgaramond/";
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    maintainers = with lib.maintainers; [
      bengsparks
      relrod
      rycee
    ];
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
  };
})
