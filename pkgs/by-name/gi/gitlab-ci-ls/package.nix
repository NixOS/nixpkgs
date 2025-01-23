{
  rustPlatform,
  lib,
  fetchFromGitHub,
  darwin,
  openssl,
  pkg-config,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitlab-ci-ls";
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "alesbrelih";
    repo = "gitlab-ci-ls";
    rev = "${version}";
    hash = "sha256-HpFdebG4pRa+g2ycOOfnWgN/+DcYdPHAN/RHBHN6S8A=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-b1G4r1z87IX3oWgVBMD9Z2+Ii3iSIL65TZWrX7wjXD0=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
    ];

  meta = with lib; {
    homepage = "https://github.com/alesbrelih/gitlab-ci-ls";
    description = "GitLab CI Language Server (gitlab-ci-ls)";
    license = licenses.mit;
    maintainers = with maintainers; [ ma27 ];
    platforms = platforms.unix;
    mainProgram = "gitlab-ci-ls";
  };
}
