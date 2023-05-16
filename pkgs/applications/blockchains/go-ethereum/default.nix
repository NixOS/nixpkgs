{ lib, stdenv, buildGoModule, fetchFromGitHub, libobjc, IOKit, nixosTests }:

let
  # A list of binaries to put into separate outputs
  bins = [
    "geth"
    "clef"
  ];

in buildGoModule rec {
  pname = "go-ethereum";
<<<<<<< HEAD
  version = "1.12.2";
=======
  version = "1.11.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-iCLOrf6/f0f7sD0YjmBtlcOcZRDIp9IZkBadTKj1Qjw=";
  };

  vendorHash = "sha256-ChmQjhz4dQdwcY/269Hi5XAn8/+0z/AF7Kd9PJ8WqHg=";
=======
    sha256 = "sha256-mZ11xan3MGgaUORbiQczKrXSrxzjvQMhZbpHnEal11Y=";
  };

  vendorHash = "sha256-rjSGR2ie5sFK2OOo4HUZ6+hrDlQuUDtyTKn0sh8jFBY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  doCheck = false;

  outputs = [ "out" ] ++ bins;

  # Move binaries to separate outputs and symlink them back to $out
  postInstall = lib.concatStringsSep "\n" (
    builtins.map (bin: "mkdir -p \$${bin}/bin && mv $out/bin/${bin} \$${bin}/bin/ && ln -s \$${bin}/bin/${bin} $out/bin/") bins
  );

  subPackages = [
    "cmd/abidump"
    "cmd/abigen"
    "cmd/bootnode"
<<<<<<< HEAD
=======
    "cmd/checkpoint-admin"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    "cmd/clef"
    "cmd/devp2p"
    "cmd/ethkey"
    "cmd/evm"
    "cmd/faucet"
    "cmd/geth"
    "cmd/p2psim"
    "cmd/rlpdump"
    "cmd/utils"
  ];

  # Following upstream: https://github.com/ethereum/go-ethereum/blob/v1.11.6/build/ci.go#L218
  tags = [ "urfave_cli_no_docs" ];

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  passthru.tests = { inherit (nixosTests) geth; };

  meta = with lib; {
    homepage = "https://geth.ethereum.org/";
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3Plus gpl3Plus ];
<<<<<<< HEAD
    maintainers = with maintainers; [ RaghavSood ];
=======
    maintainers = with maintainers; [ adisbladis RaghavSood ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
