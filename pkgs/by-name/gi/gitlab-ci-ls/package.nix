{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitlab-ci-ls";
  version = "1.1.8";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${version}";
    hash = "sha256-8386MX5jR4LNrpuXVmv+aLnfEvzSJBZgggS3Uj2MU9A=";
  };

  cargoHash = "sha256-tyx3GGhVyOOo1SnGlS02JqEhY+D70NqzKVX7WeXu+ls=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = with lib; {
    homepage = "https://github.com/alesbrelih/gitlab-ci-ls";
    description = "GitLab CI Language Server (gitlab-ci-ls)";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
    mainProgram = "gitlab-ci-ls";
  };
}
