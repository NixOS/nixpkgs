{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "di-tui";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "acaloiaro";
    repo = "di-tui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-P784Tf3XA/28PgKTr89yizKAX1MhAb4877gV7vVHBYE=";
  };

  vendorHash = "sha256-b7dG0nSjPQpjWUbOlIxWudPZWKqtq96sQaJxKvsQT9I=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple terminal UI player for di.fm";
    homepage = "https://github.com/acaloiaro/di-tui";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.acaloiaro ];
    mainProgram = "di-tui";
  };
})
