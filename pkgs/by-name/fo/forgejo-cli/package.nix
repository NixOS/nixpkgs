{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  libgit2,
  oniguruma,
  openssl,
  zlib,
  stdenv,
  darwin,
}:
let
  version = "0.1.1";
in
rustPlatform.buildRustPackage {
  pname = "forgejo-cli";
  inherit version;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Cyborus";
    repo = "forgejo-cli";
    rev = "v${version}";
    hash = "sha256-367O4SpGA0gWM/IIJjIbCoi4+N/Vl58T5Jw/NVsE+7o=";
  };

  cargoHash = "sha256-F7UBLqMXYS8heJs1mdmiFTHUfgoMKEb+KV4tiDsIRDY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [
      libgit2
      oniguruma
      openssl
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        Security
        SystemConfiguration
      ]
    );

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "CLI application for interacting with Forgejo";
    homepage = "https://codeberg.org/Cyborus/forgejo-cli";
    changelog = "https://codeberg.org/Cyborus/forgejo-cli/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "fj";
  };
}
