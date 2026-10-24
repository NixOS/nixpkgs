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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "YutaUra";
    repo = "gati";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Pp/yWZvGJq0t0HmKBbNKydBBv30aqqMO/DVp1lTrXXg=";
  };

  cargoHash = "sha256-lHgxkelhRXYbYWdtwgYzgi9IYOD9VjKnXYtu+UKXzPI=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [ oniguruma ];

  env.RUSTONIG_SYSTEM_LIBONIG = 1;

  # cli_clipboard requires a display server, unavailable in the sandbox
  checkFlags = [ "--skip=app::tests::export_sets_flash_message_on_success" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Terminal tool for reviewing code, not writing it";
    homepage = "https://github.com/YutaUra/gati";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yutaura ];
    mainProgram = "gati";
    platforms = lib.platforms.unix;
  };
})
