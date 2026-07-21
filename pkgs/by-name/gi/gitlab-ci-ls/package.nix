{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitlab-ci-ls";
  version = "1.3.3";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${finalAttrs.version}";
    hash = "sha256-VA1y24JObxUcY8BPq9xtbajBrFlcq5H1wi8j7jQtsY4=";
  };

  cargoHash = "sha256-SNc2mgfUaKYGsIDnpigMciO/l8EavlCbE8gCUSdj7aA=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    homepage = "https://github.com/alesbrelih/gitlab-ci-ls";
    description = "GitLab CI Language Server (gitlab-ci-ls)";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ma27 ];
    platforms = lib.platforms.unix;
    mainProgram = "gitlab-ci-ls";
  };
})
