{ lib, buildGoModule, fetchFromGitHub, stdenv, makeWrapper, gitMinimal }:

buildGoModule rec {
  pname = "gitsign";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "sigstore";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-lSE4BLwtxicngvnDCcMa6F6c3+Okn9NKAOnT2FGi7kU=";
  };
  vendorSha256 = "sha256-WrVunAxOXXGSbs9OyKydeg4N/s871mt2O3t2e5DxXQo=";

  nativeBuildInputs = [ makeWrapper ];

  ldflags = [ "-s" "-w" "-buildid=" "-X github.com/sigstore/gitsign/pkg/version.gitVersion=${version}" ];

  postInstall = ''
    for f in $out/bin/*; do
      wrapProgram $f --prefix PATH : ${lib.makeBinPath [ gitMinimal ]}
    done
  '';

  meta = {
    homepage = "https://github.com/sigstore/gitsign";
    changelog = "https://github.com/sigstore/gitsign/releases/tag/v${version}";
    description = "Keyless Git signing using Sigstore";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lesuisse ];
  };
}
