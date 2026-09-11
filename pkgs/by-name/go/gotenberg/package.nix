{
  lib,
  buildGo126Module,
  chromium,
  fetchFromGitHub,
  libreoffice,
  makeBinaryWrapper,
  pdftk,
  qpdf,
  mktemp,
  makeFontsConf,
  liberation_ttf_v2,
  exiftool,
  pdfcpu,
  makeWrapper,
  nixosTests,
  nix-update-script,
  stdenvNoCC,
}:
let
  fontsConf = makeFontsConf { fontDirectories = [ liberation_ttf_v2 ]; };
  jre' = libreoffice.unwrapped.jdk;
  libreoffice' = "${libreoffice}/lib/libreoffice/program/soffice.bin";
  inherit (lib) getExe;

  unoconverter = stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "unoconverter";
    version = "0.4.0";

    src = fetchFromGitHub {
      owner = "gotenberg";
      repo = "unoconverter";
      tag = "v${finalAttrs.version}";
      hash = "sha256-K3d/6jvj0Tt1e83hVTHZ0N7FzPgJsjxlUBS1nbp82zw=";
    };

    patches = [
      # Remove compatibility fixes for very old LO/OO
      # https://github.com/gotenberg/unoconverter/pull/5
      ./5.patch
    ];

    postPatch = ''
      substituteInPlace unoconv \
        --replace-fail "#!/usr/bin/env python" "#!${libreoffice.unwrapped.python.interpreter}"
    '';

    nativeBuildInputs = [
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      install -Dt $out/bin unoconv
      wrapProgram "$out/bin/unoconv" \
        --set-default UNO_PATH "${libreoffice.unwrapped}/lib/libreoffice/program/"

      runHook postInstall
    '';

    meta = {
      description = "Python script for interacting with LibreOffice";
      homepage = "https://github.com/gotenberg/unoconverter";
      license = lib.licenses.mit;
      mainProgram = "unoconv";
    };
  });
in
buildGo126Module (finalAttrs: {
  pname = "gotenberg";
  version = "8.36.0";

  outputs = [
    "out"
    "hyphen"
  ];

  src = fetchFromGitHub {
    owner = "gotenberg";
    repo = "gotenberg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mIaTANaES3FilK5345FlaVBfwaPRmryV44AJkSgak4w=";
  };

  vendorHash = "sha256-sU1yquAP63+/q102b7PkBY5hr/xlCOjS/AYDF4lp8OY=";

  postPatch = ''
    find ./pkg -name '*_test.go' -exec sed -i -e 's#/tests#${finalAttrs.src}#g' {} \;

    if ! grep -q "https://raw.githubusercontent.com/gotenberg/unoconverter/v${unoconverter.version}/unoconv" build/Dockerfile; then
      unoconverter_version=$(grep -oP 'https://raw\.githubusercontent\.com/gotenberg/unoconverter/v\K[0-9]+\.[0-9]+\.[0-9]+(?=/unoconv)' build/Dockerfile)
      echo "Our unoconverter version ${unoconverter.version} does not match upstream's version $unoconverter_version"
      exit 1
    fi
  '';

  nativeBuildInputs = [ makeBinaryWrapper ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gotenberg/gotenberg/v8/cmd.Version=${finalAttrs.version}"
  ];

  checkInputs = [
    chromium
    libreoffice
    pdftk
    qpdf
    unoconverter
    pdfcpu
    mktemp
    jre'
  ];

  preCheck = ''
    export CHROMIUM_BIN_PATH=${getExe chromium}
    export PDFTK_BIN_PATH=${getExe pdftk}
    export QPDF_BIN_PATH=${getExe qpdf}
    export UNOCONVERTER_BIN_PATH=${getExe unoconverter}
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
      --set UNOCONVERTER_BIN_PATH "${getExe unoconverter}"
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests = {
    inherit (nixosTests) gotenberg;
  };

  meta = {
    description = "Converts numerous document formats into PDF files";
    mainProgram = "gotenberg";
    homepage = "https://gotenberg.dev";
    changelog = "https://github.com/gotenberg/gotenberg/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ miniharinn ];
  };
})
