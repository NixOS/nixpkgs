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
  version = "0.6.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-oudVXG26w7LTye7M4Kr6N8rDFEuNljiNSzSAyKcHvf0=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    iconv
  ];

  cargoHash = "sha256-lr9q9J4zHF50u23UQ3RZzd9CKcPtJSy+OT2XN2tpVEo=";

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
