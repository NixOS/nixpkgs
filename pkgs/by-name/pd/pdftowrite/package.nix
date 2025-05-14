{
  lib,
  python3Packages,
  fetchFromGitHub,
  makeWrapper,
  versionCheckHook,
  nix-update-script,

  # shared
  gzip,
  # pdftowrite
  poppler-utils,
  inkscape,
  ghostscript,
  imagemagick,
  libxml2,
  libxslt,
  # writetopdf
  wkhtmltopdf,
  pdftk,
  librsvg,
}:
python3Packages.buildPythonApplication rec {
  pname = "pdftowrite";
  version = "2021.05.03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "apebl";
    repo = "pdftowrite";
    tag = version;
    hash = "sha256-IFX9K74tfGKyMtqlc/RsV00baZEzE3HcPAGfrmTHnDQ=";
  };

  dependencies = [
    python3Packages.shortuuid
    python3Packages.picosvg
  ];

  build-system = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
    makeWrapper
  ];

  patches = [
    # fix inkscape flag (see https://gitlab.com/inkscape/inkscape/-/issues/4536)
    ./inkscape-unknown-option-pdf-page.patch
  ];

  postInstall =
    let
      pdftowritePath = lib.makeBinPath [
        # shared
        gzip
        # pdftowrite
        poppler-utils
        inkscape
        ghostscript
        imagemagick
        libxml2
        libxslt
      ];
      writetopdfPath = lib.makeBinPath [
        # shared
        gzip
        # writetopdf
        wkhtmltopdf
        pdftk
        librsvg
      ];
    in
    # `SELF_CALL=xxx` prevents inkscape shananigans (see https://gitlab.com/inkscape/inkscape/-/issues/4716)
    ''
      wrapProgram $out/bin/pdftowrite --prefix PATH : ${pdftowritePath} \
        --set SELF_CALL=xxx
      wrapProgram $out/bin/writetopdf --prefix PATH : ${writetopdfPath}
    '';

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://github.com/apebl/pdftowrite";
    description = "Utility that converts PDF to Stylus Labs Write documents, and vice versa";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ henrispriet ];
  };
}
