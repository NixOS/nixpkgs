{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  version = "0.9.1";
  pname = "sccache";

  src = fetchFromGitHub {
    owner = "mozilla";
    repo = "sccache";
    rev = "v${version}";
    sha256 = "sha256-MR/zfE87Z4TXc3ta3192lG/tD7YiVrn0HCLr5O29Izo=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Cv+tIivwqNqnA8anDWWEgQKpDFktG4rGZ+qZejBoDAE=";

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs =
    [
      openssl
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  # Tests fail because of client server setup which is not possible inside the
  # pure environment, see https://github.com/mozilla/sccache/issues/460
  doCheck = false;

  meta = with lib; {
    description = "Ccache with Cloud Storage";
    mainProgram = "sccache";
    homepage = "https://github.com/mozilla/sccache";
    changelog = "https://github.com/mozilla/sccache/releases/tag/v${version}";
    maintainers = with maintainers; [
      doronbehar
      figsoda
    ];
    license = licenses.asl20;
  };
}
