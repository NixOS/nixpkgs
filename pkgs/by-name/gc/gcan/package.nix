{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gcan";
  version = "1.1.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "applicative-systems";
    repo = "gcan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BZfdc3ddAa9CPC3GOH9G3QJbECbSRY7ymzIMtYl076M=";
  };

  cargoHash = "sha256-5oE69FYTAV6JiTAN4A79+ndI0vHrbAi1JeEJcD+eY2c=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "Analyze, filter, and prune Nix GC roots";
    homepage = "https://github.com/applicative-systems/gcan";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.tfc ];
    mainProgram = "gcan";
    platforms = lib.platforms.unix;
  };
})
