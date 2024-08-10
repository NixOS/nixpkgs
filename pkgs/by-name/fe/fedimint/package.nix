{ lib
, buildPackages
, clang
, fetchFromGitHub
, libclang
, libiconv
, llvmPackages_12
, openssl
, pkg-config
, protobuf
, rustPlatform
, stdenv
, Security
, SystemConfiguration
}:
let
  # Rust rocksdb bindings have C++ compilation/linking errors on Darwin when using newer clang
  # Forcing it to clang 12 fixes the issue.
  buildRustPackage =
    if stdenv.isDarwin then
      rustPlatform.buildRustPackage.override { stdenv = llvmPackages_12.stdenv; }
    else
      rustPlatform.buildRustPackage;
in
buildRustPackage rec {
  pname = "fedimint";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "fedimint";
    repo = "fedimint";
    rev = "v${version}";
    hash = "sha256-0SsIuMCdsZdYSRA1yT1axMe6+p+tIpXyN71V+1B7jYc=";
  };

  cargoHash = "sha256-nQvEcgNOT04H5OgMHfN1713A4nbEaKK2KDx9E3qxcbM=";

  nativeBuildInputs = [
    protobuf
    pkg-config
    clang
    libclang.lib
  ];

  buildInputs = [
    openssl
  ] ++ lib.optionals stdenv.isDarwin [
    Security
    libiconv
    Security
    SystemConfiguration
  ];

  outputs = [ "out" "fedimintCli" "fedimint" "gateway" "gatewayCli" "devimint" ];

  postInstall = ''
    mkdir -p $fedimint/bin $fedimintCli/bin $gateway/bin $gatewayCli/bin $devimint/bin

    # delete fuzzing targets and other binaries no one cares about
    binsToKeep=(fedimint-cli fedimint-dbtool recoverytool fedimintd gatewayd gateway-cli gateway-cln-extension devimint)
    keepPattern=$(printf "|%s" "''${binsToKeep[@]}")
    keepPattern=''${keepPattern:1}
    find "$out/bin" -maxdepth 1 -type f | grep -Ev "(''${keepPattern})" | xargs rm -f

    # fix the upstream name
    mv $out/bin/recoverytool $out/bin/fedimint-recoverytool


    cp -a $releaseDir/fedimint-cli  $fedimintCli/bin/
    cp -a $releaseDir/fedimint-dbtool  $fedimintCli/bin/
    cp -a $releaseDir/recoverytool  $fedimintCli/bin/fedimint-recoverytool

    cp -a $releaseDir/fedimintd  $fedimint/bin/

    cp -a $releaseDir/gateway-cli $gatewayCli/bin/

    cp -a $releaseDir/gatewayd $gateway/bin/
    cp -a $releaseDir/gateway-cln-extension $gateway/bin/

    cp -a $releaseDir/devimint $devimint/bin/
  '';

  PROTOC = "${buildPackages.protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";
  OPENSSL_DIR = openssl.dev;
  LIBCLANG_PATH = "${libclang.lib}/lib";

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
