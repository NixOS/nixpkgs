{
  lib,
  buildGoModule,
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
  nixosTests,
  nix-update-script,
}:
let
  fontsConf = makeFontsConf { fontDirectories = [ liberation_ttf_v2 ]; };
  jre' = libreoffice.unwrapped.jdk;
  libreoffice' = "${libreoffice}/lib/libreoffice/program/soffice.bin";
  inherit (lib) getExe;
in
buildGoModule rec {
  pname = "gotenberg";
  version = "8.9.1";

  src = fetchFromGitHub {
    owner = "gotenberg";
    repo = "gotenberg";
    rev = "refs/tags/v${version}";
    hash = "sha256-y54DtOYIzFAk05TvXFcLdStfAXim3sVHBkW+R8CrtMM=";
  };

  vendorHash = "sha256-BYcdqZ8TNEG6popRt+Dg5xW5Q7RmYvdlV+niUNenRG0=";

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
    mktemp
    jre'
  ];

  preCheck = ''
    export CHROMIUM_BIN_PATH=${getExe chromium}
    export PDFTK_BIN_PATH=${getExe pdftk}
    export QPDF_BIN_PATH=${getExe qpdf}
    export UNOCONVERTER_BIN_PATH=${getExe unoconv}
    export EXIFTOOL_BIN_PATH=${getExe exiftool}
    # LibreOffice needs all of these set to work properly
    export LIBREOFFICE_BIN_PATH=${libreoffice'}
    export FONTCONFIG_FILE=${fontsConf}
    export HOME=$(mktemp -d)
    export JAVA_HOME=${jre'}
  '';

  # These tests fail with a panic, so disable them.
  checkFlags = [ "-skip=^TestChromiumBrowser_(screenshot|pdf)$" ];

  preFixup = ''
    wrapProgram $out/bin/gotenberg \
      --set PDFTK_BIN_PATH "${getExe pdftk}" \
      --set QPDF_BIN_PATH "${getExe qpdf}" \
      --set UNOCONVERTER_BIN_PATH "${getExe unoconv}" \
      --set EXIFTOOL_BIN_PATH "${getExe exiftool}" \
      --set JAVA_HOME "${jre'}"
  '';

  passthru.updateScript = nix-update-script { };
  passthru.tests = {
    inherit (nixosTests) gotenberg;
  };

  meta = {
    description = "Converts numerous document formats into PDF files";
    homepage = "https://gotenberg.dev";
    changelog = "https://github.com/gotenberg/gotenberg/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
