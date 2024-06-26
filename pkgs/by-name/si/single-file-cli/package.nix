{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  chromium,
  chromedriver,
  python3,
}:
buildNpmPackage {
  pname = "single-file-cli";
  version = "1.1.49";

  src = fetchFromGitHub {
    owner = "gildas-lormeau";
    repo = "single-file-cli";
    rev = "af0f6f119edd8bf82bce3860fa55cfad869ac874";
    hash = "sha256-5pozqrIIanoLF4eugLxPRsUaoUYJurliovFFBYO/mC4=";
  };
  npmDepsHash = "sha256-wiBpWw9nb/pWVGIc4Vl/IxxR5ic0LzLMMr3WxRNvYdM=";

  nativeCheckInputs = [
    chromium
    chromedriver
  ];
  doCheck = stdenv.isLinux;

  postBuild = ''
    patchShebangs ./single-file
  '';

  checkPhase = ''
    runHook preCheck

    ${python3}/bin/python -m http.server --bind 127.0.0.1 &
    pid=$!

    ./single-file \
      --browser-headless \
      --web-driver-executable-path=chromedriver \
      --back-end=webdriver-chromium \
      http://127.0.0.1:8000

    grep -F 'Page saved with SingleFile' 'Directory listing for'*.html

    kill $pid
    wait

    runHook postCheck
  '';

  meta = {
    description = "CLI tool for saving a faithful copy of a complete web page in a single HTML file";
    homepage = "https://github.com/gildas-lormeau/single-file-cli";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ n8henrie ];
    mainProgram = "single-file";
  };
}
