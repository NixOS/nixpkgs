{ lib, stdenv, buildGoModule, fetchFromGitHub, libobjc, IOKit }:

let
  # A list of binaries to put into separate outputs
  bins = [
    "geth"
  ];

in buildGoModule rec {
  pname = "go-ethereum";
  version = "1.9.25";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    sha256 = "0cbgqs17agwdap4g37sb2g6mhyn7qkqbjk7kwb5jvj8nbi5n3kbd";
  };

  runVend = true;
  vendorSha256 = "08wgah8gxb5bscm5ca6zkfgssnmw2y2l6k9gfw7gbxyflsx74lya";

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
    "cmd/checkpoint-admin"
    "cmd/clef"
    "cmd/devp2p"
    "cmd/ethkey"
    "cmd/evm"
    "cmd/faucet"
    "cmd/geth"
    "cmd/p2psim"
    "cmd/puppeth"
    "cmd/rlpdump"
    "cmd/utils"
  ];

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs =
    lib.optionals stdenv.isDarwin [ libobjc IOKit ];

  meta = with lib; {
    homepage = "https://geth.ethereum.org/";
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [ lgpl3Plus gpl3Plus ];
    maintainers = with maintainers; [ adisbladis lionello xrelkd RaghavSood ];
  };
}
