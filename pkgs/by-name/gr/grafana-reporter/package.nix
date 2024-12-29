{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch2,
  tetex,
  makeWrapper,
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

  vendorHash = "sha256-QlNOx2jm1LVz066t9khppf//T5c9z3YUrSOr6qzbUzI=";

  patches = [
    (fetchpatch2 {
      name = "use-go-mod-and-remove-vendor-dirs";
      url = "https://github.com/IzakMarais/reporter/commit/e844b3f624e0da3a960f98cade427fe54f595504.patch";
      hash = "sha256-CdI7/mkYG6t6H6ydGu7atwk18DpagdP7uzfrZVKKlhA=";
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/grafana-reporter \
      --prefix PATH : ${lib.makeBinPath [ tetex ]}
  '';

  meta = {
    description = "PDF report generator from a Grafana dashboard";
    mainProgram = "grafana-reporter";
    homepage = "https://github.com/IzakMarais/reporter";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.disassembler ];
  };
}
