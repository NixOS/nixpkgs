{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitlab-ci-ls";
  version = "1.3.2";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${finalAttrs.version}";
    hash = "sha256-b//Yi+7jOQv+pHyeS/t3OSBMCZZ34sP8xXCNivlShYQ=";
  };

  cargoHash = "sha256-BCV5LU8cVf40vCQCN56dlWiyvfvwF4nPUcLb+mOfsok=";

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
