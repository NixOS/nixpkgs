{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitlab-ci-ls";
  version = "1.3.1";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${finalAttrs.version}";
    hash = "sha256-ZZjx6VdBZuVuHl42n0iXZkvvUku2CN7x4JCZxZTMOMk=";
  };

  cargoHash = "sha256-OB44JaekEl1dJB6LGTLWXgcwYac2GA3I9Ab8xt/+rkI=";

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
