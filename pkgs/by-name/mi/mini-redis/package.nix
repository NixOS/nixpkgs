{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mini-redis";
  version = "0.4.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    sha256 = "sha256-vYphaQNMAHajod5oT/T3VJ12e6Qk5QOa5LQz6KsXvm8=";
  };

  cargoHash = "sha256-oGyJxNzJX7PwMkDoT9Tb3xF0vWgQwuyIjKPgEkbPKyI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/${finalAttrs.meta.mainProgram}";
  doCheck = false;

  meta = {
    description = "Incomplete, idiomatic implementation of a Redis client and server built with Tokio, for learning purposes";
    homepage = "https://github.com/tokio-rs/mini-redis";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nomaterials ];
    mainProgram = "mini-redis-cli";
  };
})
