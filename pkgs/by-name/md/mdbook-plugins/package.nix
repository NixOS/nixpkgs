{
  lib,
  libgit2,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  curl,
  openssl,
  sqlite,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdbook-plugins";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "RustForWeb";
    repo = "mdbook-plugins";
    rev = "v${finalAttrs.version}";
    hash = "sha256-c+FonzFVv/+BNs0bYzFE62ii2dTBB7glSOi5Xji3nBk=";
  };

  cargoHash = "sha256-ppBy3ei8r6gxcsA8MziA0FYvRAt/6Rg7I/NX/6ejukg=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    curl
    libgit2
    openssl
    sqlite
  ];

  env.OPENSSL_NO_VENDOR = true;

  cargoBuildFlags = [
    "--bin=mdbook-tabs"
    "--bin=mdbook-trunk"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Plugins for mdBook";
    homepage = "https://mdbook-plugins.rustforweb.org/";
    changelog = "https://github.com/RustForWeb/mdbook-plugins/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ redianthus ];
    mainProgram = "mdbook-tabs";
  };
})
