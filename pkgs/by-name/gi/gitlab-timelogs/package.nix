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
  version = "0.7.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-WmdN3w0t7omA2F+Fpv+PkT/hymgTzxlTSBytKep+6Lo=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    iconv
  ];

  cargoHash = "sha256-Ap/R/Sa60LUAKByzKGYzj/IZeq/UDiZzBxYY0Ell6Kw=";

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
