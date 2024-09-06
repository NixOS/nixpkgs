{
  darwin,
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
  version = "0.3.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-n+Jvm4RqHkXIeQcY55iOEBgwvbr77vLMhqxXgdau5MQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.isDarwin [
      darwin.apple_sdk.frameworks.SystemConfiguration
      iconv
    ];

  cargoHash = "sha256-REE7DWY0l4TTDTwWFWVr3Zk/oLQlOjrbFEWSFUlBEig=";

  meta = {
    description = " CLI utility to support you with your time logs in GitLab";
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
