{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "coreth";
  version = "0.12.4";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AcU/1/TBS0nT7bXYguM8KI4mBUQzvSTVwuQkzq3t3EY=";
  };

  # go mod vendor has a bug, see: golang/go#57529
  proxyVendor = true;

  vendorHash = "sha256-GVSI3yv7YzW2QPC26gA2C3TqjBnTxyiPzmW+hsGGdaQ=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/ava-labs/coreth/plugin/evm.Version=${version}"
    "-X github.com/ava-labs/coreth/cmd/abigen.gitCommit=${version}"
    "-X github.com/ava-labs/coreth/cmd/abigen.gitDate=1970-01-01"
  ];

  subPackages = [
    "cmd/abigen"
    "plugin"
  ];

  postInstall = "mv $out/bin/{plugin,evm}";

  meta = with lib; {
    description = "Code and wrapper to extract Ethereum blockchain functionalities without network/consensus, for building custom blockchain services";
    homepage = "https://github.com/ava-labs/coreth";
    changelog = "https://github.com/ava-labs/coreth/releases/tag/v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ urandom ];
  };
}
