{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "live-server";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "lomirus";
    repo = "live-server";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CV+QUwOYGg6lzEDlAlAYoKO3RqWlF3857/6rDmdLjZQ=";
  };

  cargoHash = "sha256-C/uqEz8ww+YIg1QbnYgKUPNyLnIIf8Tcf8x99PGmOG4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  __darwinAllowLocalNetworking = true;
  # Tests that require a browser
  checkFlags = [
    "--skip=browser_reloads_on_file_change"
    "--skip=page_content_is_served"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Local network server with live reload feature for static pages";
    downloadPage = "https://github.com/lomirus/live-server/releases";
    homepage = "https://github.com/lomirus/live-server";
    changelog = "https://github.com/lomirus/live-server/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "live-server";
    maintainers = with lib.maintainers; [
      philiptaron
      doronbehar
    ];
    platforms = lib.platforms.unix;
  };
})
