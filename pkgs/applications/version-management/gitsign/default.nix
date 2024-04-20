{ lib, buildGoModule, fetchFromGitHub, stdenv, makeWrapper, gitMinimal, testers, gitsign }:

buildGoModule rec {
  pname = "gitsign";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WaiGkbjqty/MsTWPvx5DmmaNwWTJAEFKwVqArt2oZZc=";
  };
  vendorHash = "sha256-p2E010k7uozpLvl9VpfG5/JyQR4mVUBKv2p78UdFlac=";

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
