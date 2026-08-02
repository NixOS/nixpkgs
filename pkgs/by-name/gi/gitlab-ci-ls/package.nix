{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitlab-ci-ls";
  version = "1.3.4";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${finalAttrs.version}";
    hash = "sha256-B5XNh1SzxTC7m5TGDgrPBTrOwbhVJCjkxcq9AAxf42k=";
  };

  cargoHash = "sha256-lAvNbDalVQfs8HMnnlSPRTqztOldvoQSG0LCHBunx8Y=";

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
