{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "coreth";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = "coreth";
    rev = "v${version}";
    hash = "sha256-aDasA9dQewT57EBgXGMmVikPT5uCYJClIYVvfoP68/U=";
  };

  # go mod vendor has a bug, see: golang/go#57529
  proxyVendor = true;

  vendorHash = "sha256-l0AAUuH9Lt2LFA9QLHom8pwS380UM5qm4ho/yivqz7Y=";

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

  meta = {
    description = "Code and wrapper to extract Ethereum blockchain functionalities without network/consensus, for building custom blockchain services";
    homepage = "https://github.com/ava-labs/coreth";
    changelog = "https://github.com/ava-labs/coreth/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ urandom ];
  };
}
