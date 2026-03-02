{
  fetchCrate,
  iconv,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "gitlab-timelogs";
  version = "0.7.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-DNMJczR4yaglIOcNmb2E1g+UP0VeJaIb5TvdKUcWzc0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    iconv
  ];

  cargoHash = "sha256-aCt534oDG9u37xLQjG7Ye+EKpTgW4q/LqaVkxw5iEJ0=";

  meta = {
    description = "CLI utility to support you with your time logs in GitLab";
    mainProgram = "gitlab-timelogs";
    longDescription = ''
      CLI utility to support you with your time logs in GitLab.

      gitlab-timelogs is not associated with the official GitLab project!
    '';
    homepage = "https://github.com/phip1611/gitlab-timelogs";
    changelog = "https://github.com/phip1611/gitlab-timelogs/blob/v${version}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [
      blitz
      phip1611
    ];
  };
}
