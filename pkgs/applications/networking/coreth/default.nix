{ buildGoModule
, fetchFromGitHub
, lib
, stdenv
}:

buildGoModule rec {
  pname = "coreth";
<<<<<<< HEAD
  version = "0.12.4";
=======
  version = "0.12.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ava-labs";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-AcU/1/TBS0nT7bXYguM8KI4mBUQzvSTVwuQkzq3t3EY=";
=======
    hash = "sha256-Wf4abvBOX98A2IjALkMMOAqDvEtXtLddxhrV2LQM1dU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # go mod vendor has a bug, see: golang/go#57529
  proxyVendor = true;

<<<<<<< HEAD
  vendorHash = "sha256-GVSI3yv7YzW2QPC26gA2C3TqjBnTxyiPzmW+hsGGdaQ=";
=======
  vendorHash = "sha256-nQfb94IileWTkSZOliDT6B6o7qQ8aQ0MdY0jzc84VIM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
=======
    # In file included from ../go/pkg/mod/github.com/zondax/hid@v0.9.1-0.20220302062450-5552068d2266/hid_enabled.go:38:
    # ./hidapi/mac/hid.c:693:34: error: use of undeclared identifier 'kIOMainPortDefault'
    #     entry = IORegistryEntryFromPath(kIOMainPortDefault, path);
    broken = stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
