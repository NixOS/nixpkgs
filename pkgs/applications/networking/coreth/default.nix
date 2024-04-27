{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "coreth";
  version = "0.13.2";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-G3Ovu/tF7gCeddmE91nht/yyqJJtgMyIi7YbTtUFyKo=";
  };

  # go mod vendor has a bug, see: golang/go#57529
  proxyVendor = true;

  vendorHash = "sha256-IJFRtoDd0GO8mIx8mmGixaYK5JDQeSpUfk0MPPX6cX8=";

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
