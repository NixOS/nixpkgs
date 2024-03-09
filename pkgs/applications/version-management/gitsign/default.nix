{ lib, buildGoModule, fetchFromGitHub, stdenv, makeWrapper, gitMinimal, testers, gitsign }:

buildGoModule rec {
  pname = "gitsign";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+oJBpERU2WbfmS7MyBbJKrh4kzY+rgSw4uKAU1y5kR4=";
  };
  vendorHash = "sha256-Z46eDqUc8Mdq9lEMx1YOuSh5zPIMQrSkbto33AmgANU=";

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
