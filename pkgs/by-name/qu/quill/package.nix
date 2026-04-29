{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  libiconv,
  udev,
  pkg-config,
  protobuf,
  buildPackages,
}:

let
  ic = fetchFromGitHub {
    owner = "dfinity";
    repo = "ic";
    rev = "c7993fa049275b6700df8dfcc02f90d0fca82f24";
    hash = "sha256-eGdBEcp2gxMz2SoRiBRANAvpg3qMgnpSSAED4jzt7bo=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "quill";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "dfinity";
    repo = "quill";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RXYn5QsRRi1888Iec4Q+e3ielkKBdgouHXlFCphZqnk=";
  };

  registry = "file://local-registry";

  preBuild = ''
    export REGISTRY_TRANSPORT_PROTO_INCLUDES=${ic}/rs/registry/transport/proto
    export IC_BASE_TYPES_PROTO_INCLUDES=${ic}/rs/types/base_types/proto
    export IC_PROTOBUF_PROTO_INCLUDES=${ic}/rs/protobuf/def
    export IC_NNS_COMMON_PROTO_INCLUDES=${ic}/rs/nns/common/proto
    export IC_ICRC1_ARCHIVE_WASM_PATH=${ic}/rs/ledger_suite/icrc1/wasm/ic-icrc1-archive.wasm.gz
    export LEDGER_ARCHIVE_NODE_CANISTER_WASM_PATH=${ic}/rs/ledger_suite/icp/wasm/ledger-archive-node-canister.wasm
    cp ${ic}/rs/ledger_suite/icp/ledger.did /build/quill-${finalAttrs.version}-vendor/ledger.did
    export PROTOC=${buildPackages.protobuf}/bin/protoc
    export OPENSSL_DIR=${openssl.dev}
    export OPENSSL_LIB_DIR=${lib.getLib openssl}/lib
  '';

  cargoHash = "sha256-oV+0yP2EHTjiCb3LK8xAp+8jPZs6m5J7EdFFNDlYujA=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [
    openssl
    udev
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  meta = {
    homepage = "https://github.com/dfinity/quill";
    changelog = "https://github.com/dfinity/quill/releases/tag/v${finalAttrs.version}";
    description = "Minimalistic ledger and governance toolkit for cold wallets on the Internet Computer";
    mainProgram = "quill";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.imalison ];
  };
})
