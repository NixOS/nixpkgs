{
  lib,
  buildPackages,
  fetchFromGitHub,
  openssl,
  pkg-config,
  protobuf,
  rustPlatform,
  version ? "0.7.1",
  hash ? "sha256-7meBYUN7sG1OAtMEm6I66+ptf4EfsbA+dm5/4P3IRV4=",
  cargoHash ? "sha256-4cFuasH2hvrnzTBTFifHEMtXZKsBv7OVpuwPlV19GGw=",
}:

rustPlatform.buildRustPackage rec {
  pname = "fedimint";
  inherit version;

  src = fetchFromGitHub {
    owner = "fedimint";
    repo = "fedimint";
    rev = "v${version}";
    inherit hash;
  };

  inherit cargoHash;

  nativeBuildInputs = [
    protobuf
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    openssl
  ];

  outputs = [
    "out"
    "fedimintCli"
    "fedimint"
    "gateway"
    "gatewayCli"
    "devimint"
  ];

  postInstall = ''
    mkdir -p $fedimint/bin $fedimintCli/bin $gateway/bin $gatewayCli/bin $devimint/bin

    # delete fuzzing targets and other binaries no one cares about
    binsToKeep=(fedimint-cli fedimint-dbtool recoverytool fedimintd gatewayd gateway-cli devimint)
    keepPattern=$(printf "|%s" "''${binsToKeep[@]}")
    keepPattern=''${keepPattern:1}
    find "$out/bin" -maxdepth 1 -type f | grep -Ev "(''${keepPattern})" | xargs rm -f

    cp -a $releaseDir/fedimint-cli  $fedimintCli/bin/
    cp -a $releaseDir/fedimint-dbtool  $fedimintCli/bin/
    cp -a $releaseDir/fedimint-recoverytool  $fedimintCli/bin/

    cp -a $releaseDir/fedimintd  $fedimint/bin/

    cp -a $releaseDir/gateway-cli $gatewayCli/bin/

    cp -a $releaseDir/gatewayd $gateway/bin/

    cp -a $releaseDir/devimint $devimint/bin/
  '';

  PROTOC = "${buildPackages.protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";
  OPENSSL_DIR = openssl.dev;

  FEDIMINT_BUILD_FORCE_GIT_HASH = "0000000000000000000000000000000000000000";

  # currently broken, will require some upstream fixes
  doCheck = false;

  meta = {
    description = "Federated E-Cash Mint";
    homepage = "https://github.com/fedimint/fedimint";
    license = [ lib.licenses.mit ];
    maintainers = with lib.maintainers; [ dpc ];
    mainProgram = "fedimint-cli";
  };
}
