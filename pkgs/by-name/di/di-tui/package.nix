{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitea,
}:
buildGoModule (finalAttrs: {
  pname = "di-tui";
  version = "1.15.1";

  src = fetchFromGitea {
    domain = "code.adriano.fyi";
    owner = "me";
    repo = "di-tui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y9WyGRDyXVN1mP7BueYnH+XLzKSWYhPhnbxTxpuuVDQ=";
  };

  vendorHash = "sha256-b7dG0nSjPQpjWUbOlIxWudPZWKqtq96sQaJxKvsQT9I=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple terminal UI player for di.fm";
    homepage = "https://code.adriano.fyi/me/di-tui";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.acaloiaro ];
    mainProgram = "di-tui";
  };
})
