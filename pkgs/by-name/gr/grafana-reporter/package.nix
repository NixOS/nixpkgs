{ lib
, buildGoModule
, fetchFromGitHub
, tetex
, makeWrapper
}:
buildGoModule rec {
  pname = "reporter";
  version = "2.3.1";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "IzakMarais";
    repo = "reporter";
    hash = "sha256-lsraJwx56I2Gn8CePWUlQu1qdMp78P4xwPzLxetYUcw=";
  };

  nativeBuildInputs = [ makeWrapper ];

  vendorHash = null;

  postPatch = ''
    go mod init github.com/IzakMarais/reporter
  '';

  postInstall = ''
    wrapProgram $out/bin/grafana-reporter \
      --prefix PATH : ${lib.makeBinPath [ tetex ]}
  '';

  # Testing library used had a breaking API change and upstream didn't adapt.
  doCheck = false;

  meta = {
    description = "PDF report generator from a Grafana dashboard";
    mainProgram = "grafana-reporter";
    homepage = "https://github.com/IzakMarais/reporter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.disassembler ];
  };
}
