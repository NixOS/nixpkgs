{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, withPcre2 ? stdenv.hostPlatform.isLinux
, pcre2
, testers
, rare-regex
}:

buildGoModule rec {
  pname = "rare";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "zix99";
    repo = "rare";
    rev = version;
    hash = "sha256-T27RBIrIXlhFBjzNgN6B49qgTHcek8MajXlbRC5DTMs=";
  };

  vendorHash = "sha256-wUOtxNjL/4MosACCzPTWKWrnMZhxINfN1ppkRsqDh9M=";

  buildInputs = lib.optionals withPcre2 [
    pcre2
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${version}"
    "-X=main.buildSha=${src.rev}"
  ];

  tags = lib.optionals withPcre2 [
    "pcre2"
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = rare-regex;
    };
  };

  meta = with lib; {
    description = "Fast text scanner/regex extractor and realtime summarizer";
    homepage = "https://rare.zdyn.net";
    changelog = "https://github.com/zix99/rare/releases/tag/${src.rev}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
  };
}
