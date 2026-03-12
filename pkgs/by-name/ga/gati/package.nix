{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  oniguruma,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gati";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "YutaUra";
    repo = "gati";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0zuu3bewFQ2ArlLxBRS6JMJPCyqZCOd/R+vCo9ZahvA=";
  };

  cargoHash = "sha256-uEukQsY57ZtShJhor4856zw+9lmBDkPn2kl6mjsBxIM=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [ oniguruma ];

  RUSTONIG_SYSTEM_LIBONIG = 1;

  # cli_clipboard requires a display server, unavailable in the sandbox
  checkFlags = [ "--skip=app::tests::export_sets_flash_message_on_success" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A terminal tool for reviewing code, not writing it";
    homepage = "https://github.com/YutaUra/gati";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yutaura ];
    mainProgram = "gati";
    platforms = lib.platforms.unix;
  };
})
