{ lib
, fetchFromGitHub
, openssl
, pkg-config
, protobuf
, rustPlatform
, buildPackages
, git
, stdenv
, libiconv
, clang
, libclang
, Security
, SystemConfiguration
}:
rustPlatform.buildRustPackage rec {
  pname = "fedimint";
  version = "0.3.2-rc.0";

  src = fetchFromGitHub {
    owner = "fedimint";
    repo = "fedimint";
    rev = "v${version}";
    hash = "sha256-eOGmx/freDQLxZ48nP9Y2kA84F6sdig6qfZwnJfOB3g=";
  };

  cargoHash = "sha256-2ctrZLvovgMpxZPFtmblZ/NGyxievE6FmzC4BBGuw6g=";

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
