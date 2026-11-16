{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "batmon";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "6543";
    repo = "batmon";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rmZ5mgZXLtX+Mx/1wC30pyVcZZK2UUQYbjHvGhMsJKk=";
  };

  cargoHash = "sha256-cpvlMPykWQblLLzQq8+GxC3l5bzz/f4lqcJvBYv5hsc=";

  meta = {
    description = "Interactive batteries viewer";
    longDescription = ''
      An interactive viewer, similar to top, htop and other *top utilities,
      but about the batteries installed in your notebook.
    '';
    homepage = "https://github.com/6543/batmon/";
    changelog = "https://github.com/6543/batmon/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "batmon";
    platforms = with lib.platforms; unix ++ windows;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [ _6543 ];
  };
})
