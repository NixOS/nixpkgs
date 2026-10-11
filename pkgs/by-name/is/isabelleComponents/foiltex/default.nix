{
  stdenvNoCC,
  lib,
  writableTmpDirAsHomeHook,
  fetchurl,
  texliveSmall,
  writeTextFile,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "latex-foiltex";
  version = "2.1.4b";

  outputs = [
    "tex"
    "texdoc"
  ];

  srcs = [
    (fetchurl {
      url = "http://mirrors.ctan.org/macros/latex/contrib/foiltex/foiltex.dtx";
      hash = "sha256-/2I2xHXpZi0S988uFsGuPV6hhMw8e0U5m/P8myf42R0=";
    })
    (fetchurl {
      url = "http://mirrors.ctan.org/macros/latex/contrib/foiltex/foiltex.ins";
      hash = "sha256-KTm3pkd+Cpu0nSE2WfsNEa56PeXBaNfx/sOO2Vv0kyc=";
    })
  ];

  unpackPhase = ''
    runHook preUnpack

    for _src in $srcs; do
      cp "$_src" $(stripHash "$_src")
    done

    runHook postUnpack
  '';

  nativeBuildInputs = [
    (texliveSmall.withPackages (
      ps: with ps; [
        cm-super
        hypdoc
        latexmk
      ]
    ))
    writableTmpDirAsHomeHook # Need a writable $HOME for latexmk
  ];

  # multiple-outputs.sh fails if $out is not defined
  preHook = ''
    out="''${tex-}"
  '';

  dontConfigure = true;

  buildPhase = ''
    runHook preBuild

    # Generate the style files
    latex foiltex.ins

    # Generate the documentation
    latexmk -pdf foiltex.dtx

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    path="$tex/tex/latex/foiltex"
    mkdir -p "$path"
    cp *.{cls,def,clo,sty} "$path/"

    path="$texdoc/doc/tex/latex/foiltex"
    mkdir -p "$path"
    cp *.pdf "$path/"

    runHook postInstall
  '';

  passthru = {
    tlDeps = ps: [ ps.latex ];
    settings = writeTextFile {
      name = "foiltex-settings";
      text = ''
        ISABELLE_FOILTEX_HOME="${finalAttrs.finalPackage.tex}/tex/latex/foiltex"
      '';
      destination = "/etc/settings";
    };
  };

  meta = {
    description = "LaTeX2e class for overhead transparencies";
    homepage = "https://ctan.org/pkg/foiltex";
    license = lib.licenses.unfreeRedistributable;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    platforms = lib.platforms.all;
  };
})
