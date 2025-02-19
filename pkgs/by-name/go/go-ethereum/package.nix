{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  libobjc,
  IOKit,
  nixosTests,
}:

let
  # A list of binaries to put into separate outputs
  bins = [
    "geth"
    "clef"
  ];

in
buildGoModule rec {
  pname = "go-ethereum";
  version = "1.15.0";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qfk9G3/wzeh8Nf7BG4Qv6It/bY1ZYoYyHsgoqgCyd6E=";
  };

  proxyVendor = true;
  vendorHash = "sha256-gTwmtrdj3+Pa4UxaUuhwk2Dtgur82Tbd0ict1cgVinw=";

  doCheck = false;

  outputs = [ "out" ] ++ bins;

  # Move binaries to separate outputs and symlink them back to $out
  postInstall = lib.concatStringsSep "\n" (
    builtins.map (
      bin:
      "mkdir -p \$${bin}/bin && mv $out/bin/${bin} \$${bin}/bin/ && ln -s \$${bin}/bin/${bin} $out/bin/"
    ) bins
  );

  subPackages = [
    "cmd/abidump"
    "cmd/abigen"
    "cmd/blsync"
    "cmd/clef"
    "cmd/devp2p"
    "cmd/era"
    "cmd/ethkey"
    "cmd/evm"
    "cmd/geth"
    "cmd/rlpdump"
    "cmd/utils"
  ];

  # Following upstream: https://github.com/ethereum/go-ethereum/blob/v1.11.6/build/ci.go#L218
  tags = [ "urfave_cli_no_docs" ];

  # Fix for usb-related segmentation faults on darwin
  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    libobjc
    IOKit
  ];

  passthru.tests = { inherit (nixosTests) geth; };

  meta = with lib; {
    homepage = "https://geth.ethereum.org/";
    description = "Official golang implementation of the Ethereum protocol";
    license = with licenses; [
      lgpl3Only
      gpl3Only
    ];
    maintainers = with maintainers; [
      asymmetric
      RaghavSood
    ];
    mainProgram = "geth";
  };
}
