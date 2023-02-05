{ IOKit
, buildGoModule
, fetchFromGitHub
, fetchpatch
, lib
, stdenv
}:

buildGoModule rec {
  pname = "avalanchego";
  version = "1.9.8";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5Zyrmo74k6Pl2pyVo3oX/haFsR8mHlM05ubPllintFQ=";
  };

  vendorHash = "sha256-CpXszXmySPHQehFy6XSOJFXq8ZGixO928+zrP7/vwCQ=";
  # go mod vendor has a bug, see: https://github.com/golang/go/issues/57529
  proxyVendor = true;

  buildInputs = lib.optionals stdenv.isDarwin [ IOKit ];

  subPackages = [ "main" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ava-labs/avalanchego/version.GitCommit=${version}"
  ];

  postInstall = ''
    mv $out/bin/{main,${pname}}
  '';

  meta = with lib; {
    description = "Go implementation of an Avalanche node";
    homepage = "https://github.com/ava-labs/avalanchego";
    changelog = "https://github.com/ava-labs/avalanchego/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ urandom ];
  };
}
