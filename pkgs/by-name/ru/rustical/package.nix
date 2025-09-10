{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rustical";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "lennart-k";
    repo = "rustical";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2nKK+mVBbgaz0jgey54nAXeRQ2arVUvBUoTmQviL44k=";
  };

  cargoHash = "sha256-e87lVUXznWpbfp17bAYKMa6gIyBKGwwFWzXBdlNMPYU=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env.OPENSSL_NO_VENDOR = true;

  meta = {
    description = "Yet another calendar server aiming to be simple, fast and passwordless";
    homepage = "https://github.com/lennart-k/rustical";
    changelog = "https://github.com/lennart-k/rustical/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ PopeRigby ];
    mainProgram = "rustical";
  };
})
