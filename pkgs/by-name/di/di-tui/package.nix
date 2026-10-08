{
  lib,
  nix-update-script,
  buildGoModule,
  fetchFromGitea,
}:
buildGoModule (finalAttrs: {
  pname = "di-tui";
  version = "1.15.0";

  src = fetchFromGitea {
    domain = "code.adriano.fyi";
    owner = "me";
    repo = "di-tui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-3dYcecrDSfd5sP5PjkagbFt2RmhaQSVw6kMt9J7wyeM=";
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
