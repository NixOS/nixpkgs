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
  poppler_utils,
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
python3Packages.buildPythonPackage rec {
  pname = "pdftowrite";
  version = "2021.05.03";

  src = fetchFromGitHub {
    owner = "apebl";
    repo = "pdftowrite";
    tag = version;
    hash = "sha256-IFX9K74tfGKyMtqlc/RsV00baZEzE3HcPAGfrmTHnDQ=";
  };

  dependencies = [
    # shared
    gzip
    python3Packages.shortuuid
    python3Packages.picosvg
    # pdftowrite
    poppler_utils
    inkscape
    ghostscript
    imagemagick
    libxml2
    libxslt
    # writetopdf
    wkhtmltopdf
    pdftk
    librsvg

    makeWrapper
  ];

  build-system = [
    python3Packages.setuptools
    python3Packages.setuptools-scm
  ];

  # fix inkscape flag (see https://gitlab.com/inkscape/inkscape/-/issues/4536)
  patches = [
    ./inkscape-unknown-option-pdf-page.patch
  ];

  # prevent inkscape shananigans (see https://gitlab.com/inkscape/inkscape/-/issues/4716)
  postInstall = ''
    wrapProgram $out/bin/pdftowrite --set SELF_CALL=xxx
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
