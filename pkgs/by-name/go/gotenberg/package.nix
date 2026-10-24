{
  lib,
  buildGo126Module,
  chromium,
  fetchFromGitHub,
  fetchpatch,
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
    version = "0.3.0";

    src = fetchFromGitHub {
      owner = "gotenberg";
      repo = "unoconverter";
      tag = "v${finalAttrs.version}";
      hash = "sha256-HLmv9qGpqG2H9P6hywuBeKvDYaVmWDQE2rk7rYoF6F4=";
    };

    patches = [
      # Remove compatibility fixes for very old LO/OO
      # https://github.com/gotenberg/unoconverter/pull/5
      (fetchpatch {
        url = "https://github.com/gotenberg/unoconverter/commit/22c69eef64fbefda9e56c49a95f518e2957bec0d.patch";
        hash = "sha256-VG27CneaIQeLLPmNZZrWeQ3xVM08NCsi8zqeKfHVt1s=";
      })
      (fetchpatch {
        url = "https://github.com/gotenberg/unoconverter/commit/5940b20d7c225825e886bd21f8c6c79241b1c8aa.patch";
        hash = "sha256-gQh6s4u4one+m3vv+ccSdbN+vNMVeqXfBSnhvWppHn0=";
      })
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
  version = "8.34.0";

  outputs = [
    "out"
    "hyphen"
  ];

  src = fetchFromGitHub {
    owner = "gotenberg";
    repo = "gotenberg";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HFRymNfhQOBzXBWZhiujr8sn4m/hpfjcBGg/3/C67DU=";
  };

  vendorHash = "sha256-njyxP+1S1ebaF9xJ1kBL9HrTWMTdEhu8MwUF6FYKHvs=";

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
