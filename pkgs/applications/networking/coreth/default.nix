{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "coreth";
  version = "0.11.6";

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Me+kmEfvSJs8EPU4D7MwkEyHQuvDmQCSIATxygXws5o=";
  };

  # go mod vendor has a bug, see: golang/go#57529
  proxyVendor = true;

  vendorHash = "sha256-jI01tdAVdJOj/ocpwCiaANdyYKSLw00bV7ZtU7HvslA=";

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
    # In file included from ../go/pkg/mod/github.com/zondax/hid@v0.9.1-0.20220302062450-5552068d2266/hid_enabled.go:38:
    # ./hidapi/mac/hid.c:693:34: error: use of undeclared identifier 'kIOMainPortDefault'
    #     entry = IORegistryEntryFromPath(kIOMainPortDefault, path);
    broken = stdenv.isDarwin;
  };
}
