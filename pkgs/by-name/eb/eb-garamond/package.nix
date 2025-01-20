{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  python3,
  ttfautohint,
}:
stdenvNoCC.mkDerivation rec {
  pname = "eb-garamond";
  version = "0.016";

  src = fetchFromGitHub {
    owner = "georgd";
    repo = "EB-Garamond";
    tag = "v${version}";
    hash = "sha256-ajieKhTeH6yv2qiE2xqnHFoMS65//4ZKiccAlC2PXGQ=";
  };

  nativeBuildInputs = [
    (python3.withPackages (p: [ p.fontforge ]))
    ttfautohint
  ];

  buildPhase = ''
    runHook preBuild
    make TAG_COMMIT=${src.rev} TAG=v${version} COMMIT=${src.rev} DATE=19700101
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 build/*.ttf  -t $out/share/fonts/truetype
    install -Dm644 build/*.otf  -t $out/share/fonts/opentype
    install -Dm644 web/*.woff   -t $out/share/fonts/woff

    install -Dm644 Changes README.md README.xelualatex -t $out/share/doc/${pname}-${version}

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "http://www.georgduffner.at/ebgaramond/";
    description = "Digitization of the Garamond shown on the Egenolff-Berner specimen";
    maintainers = with maintainers; [
      relrod
      rycee
    ];
    license = licenses.ofl;
    platforms = platforms.all;
  };
}
