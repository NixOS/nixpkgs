{
  rustPlatform,
  lib,
  fetchFromGitHub,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitlab-ci-ls";
  version = "1.1.2";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${version}";
    hash = "sha256-0AVi/DyaWh+dCXm/jUf3M63KjobJWCCKHDvm1xGUzCw=";
  };

  cargoHash = "sha256-3Ko+vf24dEfu+g4yGA5xY0R0TA9fSWuG398DxhHIVFU=";

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
