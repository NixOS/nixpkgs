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
  pname = "rustmission";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "intuis";
    repo = "rustmission";
    rev = "v${version}";
    hash = "sha256-vQ6MBbzmOBgD1kcF62NmQys737QEN9isvFN7L7mP8mk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GwSf/o90RO6LURIcm/kYA8oXmnCJ1OkM+eHkyZduOt0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.CoreFoundation
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  # There is no tests
  doCheck = false;

  meta = {
    description = "A TUI for the Transmission daemon";
    homepage = "https://github.com/intuis/rustmission";
    changelog = "https://github.com/intuis/rustmission/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "rustmission";
    maintainers = with lib.maintainers; [ anas ];
    platforms = with lib.platforms; unix ++ windows;
  };
}
