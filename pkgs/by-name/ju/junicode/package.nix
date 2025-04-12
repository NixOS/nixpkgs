{
  lib,
  stdenvNoCC,
  fetchzip,
  texlive,
  callPackage,
}:

stdenvNoCC.mkDerivation rec {
  pname = "junicode";
  version = "2.209";

  src = fetchzip {
    url = "https://github.com/psb1558/Junicode-font/releases/download/v${version}/Junicode_${version}.zip";
    hash = "sha256-hdCDLwTiyE2ZpFgmYAX7YWCujUwozIozD+k/lCStJUg=";
  };

  outputs = [
    "out"
    "doc"
    "tex"
  ];

  patches = [ ./tex-font-path.patch ];

  postPatch = ''
    substituteInPlace TeX/junicode.sty \
      --replace '@@@opentype_path@@@' "$out/share/fonts/opentype/" \
      --replace '@@@truetype_path@@@' "$out/share/fonts/truetype/"
    substituteInPlace TeX/junicodevf.sty \
      --replace '@@@truetype_path@@@' "$out/share/fonts/truetype/"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm 444 -t $out/share/fonts/truetype TTF/*.ttf VAR/*.ttf
    install -Dm 444 -t $out/share/fonts/opentype OTF/*.otf
    install -Dm 444 -t $out/share/fonts/woff2 WOFF2/*.woff2

    install -Dm 444 -t $doc/share/doc/${pname}-${version} docs/*.pdf

    install -Dm 444 -t $tex/tex/latex/junicode TeX/junicode.sty
    install -Dm 444 -t $tex/tex/latex/junicodevf TeX/junicodevf.{sty,lua}

    runHook postInstall
  '';

  passthru = {
    tlDeps = with texlive; [
      xkeyval
      fontspec
    ];

    tests = callPackage ./tests.nix { };
  };

  meta = {
    homepage = "https://github.com/psb1558/Junicode-font";
    description = "Unicode font for medievalists";
    maintainers = with lib.maintainers; [ ivan-timokhin ];
    license = lib.licenses.ofl;
  };
}
