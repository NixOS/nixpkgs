{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitlab-ci-ls";
  version = "1.4.0";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${finalAttrs.version}";
    hash = "sha256-NOPvNm+bdX+iFeBopRF4RFKFM4xfKi2WabuBhpMm6vQ=";
  };

  cargoHash = "sha256-sOrhE1Uqnm45eWEj6+qTbmn7ie3HoPsah5ZzWLCqLnA=";

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
