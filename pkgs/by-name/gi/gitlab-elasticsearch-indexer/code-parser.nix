{
  lib,
  fetchFromGitLab,
  rustPlatform,
  pkg-config,
  openssl,
  clang,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitlab-code-parser";
  version = "0.21.1";

  src = fetchFromGitLab {
    owner = "gitlab-org";
    repo = "rust/gitlab-code-parser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aA1zwauomznayHVGRdoQYaaba8Mq39LzjSwrvVivN2E=";
  };

  cargoHash = "sha256-oiYV+o30NrLkewfEU0z8OzkaHFWExa2gbExewHBDxSo=";

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
