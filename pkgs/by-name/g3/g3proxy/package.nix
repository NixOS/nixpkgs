{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  stdenv,
  darwin,
  c-ares,
  python3,
  lua5_4,
  capnproto,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "g3";
  version = "v1.10.4";

  src = fetchFromGitHub {
    owner = "bytedance";
    repo = "g3";
    tag = "g3proxy-${version}";
    hash = "sha256-uafKYyzjGdtC+oMJG1wWOvgkSht/wTOzyODcPoTfOnU=";
  };

  cargoHash = "sha256-NbrJGGnpZkF7ZX3MqrMsZ03tWkN/nqWahh00O3IJGOw=";
  useFetchCargoVendor = true;

  # TODO: can we unvendor AWS LC somehow?
  buildFeatures = [
    "vendored-aws-lc"
    "rustls-aws-lc"
  ];

  # aws-lc/crypto compilation will trigger `strictoverflow` errors.
  hardeningDisable = [ "strictoverflow" ];

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    python3
    capnproto
    cmake
  ];

  buildInputs =
    [
      c-ares
      lua5_4
    ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
    ];

  meta = {
    description = "Enterprise-oriented Generic Proxy Solutions";
    homepage = "https://github.com/bytedance/g3";
    changelog = "https://github.com/bytedance/g3/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ raitobezarius ];
    mainProgram = "g3proxy";
  };
}
