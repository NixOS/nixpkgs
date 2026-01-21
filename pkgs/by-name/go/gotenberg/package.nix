{
  lib,
  buildGo125Module,
  chromium,
  fetchFromGitHub,
  libreoffice,
  makeBinaryWrapper,
  pdftk,
  qpdf,
  unoconv,
  mktemp,
  makeFontsConf,
  liberation_ttf_v2,
  exiftool,
  pdfcpu,
  nixosTests,
  nix-update-script,
}:
let
  fontsConf = makeFontsConf { fontDirectories = [ liberation_ttf_v2 ]; };
  jre' = libreoffice.unwrapped.jdk;
  libreoffice' = "${libreoffice}/lib/libreoffice/program/soffice.bin";
  inherit (lib) getExe;
in
buildGo125Module rec {
  pname = "gotenberg";
  version = "8.25.1";

  outputs = [
    "out"
    "hyphen"
  ];

  src = fetchFromGitHub {
    owner = "gotenberg";
    repo = "gotenberg";
    tag = "v${version}";
    hash = "sha256-qQuK7ylwKeBI+ijScFB2jTd0nmb+tGuk09AOFroDIG0=";
  };

  vendorHash = "sha256-uQDRo5TbT+9s0YZxcUqOESHU9hTvXAMrIiaz/6ZZEAY=";

  postPatch = ''
    find ./pkg -name '*_test.go' -exec sed -i -e 's#/tests#${src}#g' {} \;
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gotenberg/gotenberg/v8/cmd.Version=${version}"
  ];

  checkInputs = [
    chromium
    libreoffice
    pdftk
    qpdf
    unoconv
    pdfcpu
    mktemp
    jre'
  ];

  preCheck = ''
    export CHROMIUM_BIN_PATH=${getExe chromium}
    export PDFTK_BIN_PATH=${getExe pdftk}
    export QPDF_BIN_PATH=${getExe qpdf}
    export UNOCONVERTER_BIN_PATH=${getExe unoconv}
    export EXIFTOOL_BIN_PATH=${getExe exiftool}
    export PDFCPU_BIN_PATH=${getExe pdfcpu}
    # LibreOffice needs all of these set to work properly
    export LIBREOFFICE_BIN_PATH=${libreoffice'}
    export FONTCONFIG_FILE=${fontsConf}
    export HOME=$(mktemp -d)
    export JAVA_HOME=${jre'}
  '';

  # These tests fail with a panic, so disable them.
  checkFlags =
    let
      skippedTests = [
        "TestChromiumBrowser_(screenshot|pdf)"
        "TestNewContext"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "$|^" skippedTests}$" ];

  postInstall = ''
    mkdir $hyphen
    cp -r build/chromium-hyphen-data/*/* $hyphen/
  '';

  preFixup = ''
    wrapProgram $out/bin/gotenberg \
      --set CHROMIUM_HYPHEN_DATA_DIR_PATH "$hyphen" \
      --set EXIFTOOL_BIN_PATH "${getExe exiftool}" \
      --set JAVA_HOME "${jre'}" \
      --set PDFCPU_BIN_PATH "${getExe pdfcpu}" \
      --set PDFTK_BIN_PATH "${getExe pdftk}" \
      --set QPDF_BIN_PATH "${getExe qpdf}" \
      --set UNOCONVERTER_BIN_PATH "${getExe unoconv}"
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests = {
    inherit (nixosTests) gotenberg;
  };

  meta = {
    description = "Converts numerous document formats into PDF files";
    mainProgram = "gotenberg";
    homepage = "https://gotenberg.dev";
    changelog = "https://github.com/gotenberg/gotenberg/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
