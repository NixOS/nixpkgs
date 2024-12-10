{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "openrisk";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "projectdiscovery";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8DGwNoucLpdazf9r4PZrN4DEOMpTr5U7tal2Rab92pA=";
  };

  vendorHash = "sha256-BLowqqlMLDtsthS4uKeycmtG7vASG25CARGpUcuibcw=";

  meta = with lib; {
    description = "Tool that generates an AI-based risk score";
    mainProgram = "openrisk";
    homepage = "https://github.com/projectdiscovery/openrisk";
    changelog = "https://github.com/projectdiscovery/openrisk/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
