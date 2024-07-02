{ stdenv, lib, fetchFromGitHub, rustPlatform, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "leftwm-theme";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm-theme";
    rev = "refs/tags/v${version}";
    hash = "sha256-tYT1eT7Rbs/6zZcl9eWsOA651dUGoXc7eRtVK8fn610=";
  };

  cargoHash = "sha256-aT1aMtpgHqtgBjL3CuRlPkuKirvb7x/SQWMuWhDBvOs=";

  checkFlags = [
    # direct writing /tmp
    "--skip=models::config::test::test_config_new"
    # with network access when testing
    "--skip=operations::update::test::test_update_repos"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  env = {
    OPENSSL_NO_VENDOR = 1;
  };

  meta = {
    description = "A theme manager for LeftWM";
    homepage = "https://github.com/leftwm/leftwm-theme";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ denperidge ];
  };
}
