{
  lib,
  fetchFromGitLab,
  rustPackages_1_88,
  pkg-config,
  openssl,
  clang,
}:
let
  rustPlatform = rustPackages_1_88.rustPlatform;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitlab-code-parser";
  version = "0.19.3";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "rust/gitlab-code-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gwldgZsiHjNafebtgiy5mVAmNNAj0Mz+krz4sI18zj4=";
  };

  cargoHash = "sha256-h6JWOhdjN4Ikwzvuv7PIYmsk1KxJyGHbjibJKVWtExY=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    clang
  ];
  buildInputs = [
    openssl.dev
  ];

  preInstall = ''
    mkdir -p $out/include
    cp crates/parser-c-bindings/target/include/parser-c-bindings.h $out/include
  '';

  meta = {
    description = "A single, efficient and extensible static code‑analysis library";
    changelog = "https://gitlab.com/gitlab-org/rust/gitlab-code-parser/-/blob/v${finalAttrs.version}/CHANGELOG.md?ref_type=tags";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ leona ];
  };
})
