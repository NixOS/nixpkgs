{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  perl,
  nasm,
  stdenv,
  openssl,
  oniguruma,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "shiki";
  version = "0.8.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "sazardev";
    repo = "shiki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A78tDlq6FdWD3KhfWWlTJHhTg4dW0/FKDLQq6Kec1pU=";
  };

  cargoHash = "sha256-SRWB+DY/TWKk8NhG1aiARBooHuR5LD71brzvPkgNs14=";

  nativeBuildInputs = [
    pkg-config
    cmake
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isx86_64 [ nasm ];

  buildInputs = [
    openssl
    oniguruma
  ];

  env = {
    # git2 hardcodes the vendored-openssl feature
    OPENSSL_NO_VENDOR = 1;
    # syntect's default features pull in onig_sys
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  meta = {
    description = "TUI note-taking app with a Yazi-style three-pane layout and modal navigation, notes as plain Markdown + YAML frontmatter, each notebook its own git repo";
    homepage = "https://github.com/sazardev/shiki";
    changelog = "https://github.com/sazardev/shiki/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sazardev ];
    mainProgram = "shiki";
  };
})
