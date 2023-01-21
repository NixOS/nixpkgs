{ stdenv, lib, fetchFromGitHub, rustPlatform, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "leftwm-theme";
  version = "unstable-2022-12-24";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = pname;
    rev = "7f2292f91f31d14a30d49372198c0e7cbe183223";
    sha256 = "sha256-tYT1eT7Rbs/6zZcl9eWsOA651dUGoXc7eRtVK8fn610=";
  };

  cargoSha256 = "sha256-3ZwVmyLvDq2z1FEqNuBlEgJLQ9KwcWj/jRlPNCNjCE4=";

  checkFlags = [
    # direct writing /tmp
    "--skip=models::config::test::test_config_new"
    # with network access when testing
    "--skip=operations::update::test::test_update_repos"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A theme manager for LeftWM";
    homepage = "https://github.com/leftwm/leftwm-theme";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ yanganto ];
  };
}
