{ lib, buildGoModule, fetchFromGitHub, stdenv, makeWrapper, gitMinimal, testers, gitsign }:

buildGoModule rec {
  pname = "gitsign";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-52Vyh2aImus9ZTb082N2FRMIsfykfQ2+AVUT2VD6lJ4=";
  };
  vendorHash = "sha256-fQTd7J2l7W3E5RQIr2hn2wp9CPHn8N8TpDqfbb3TFgI=";

  subPackages = [
    "."
    "cmd/gitsign-credential-cache"
  ];

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [ "-s" "-w" "-X github.com/sigstore/gitsign/pkg/version.gitVersion=${version}" ];

  preCheck = ''
    # test all paths
    unset subPackages
  '';

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
    done
  '';

  passthru.tests.version = testers.testVersion { package = gitsign; };

  meta = {
    homepage = "https://github.com/sigstore/gitsign";
    changelog = "https://github.com/sigstore/gitsign/releases/tag/v${version}";
    description = "Keyless Git signing using Sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lesuisse developer-guy ];
  };
}
