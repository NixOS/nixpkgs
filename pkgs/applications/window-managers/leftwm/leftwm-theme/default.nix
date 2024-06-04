{ stdenv, lib, fetchFromGitHub, rustPlatform, openssl, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "leftwm-theme";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = pname;
    rev = "v" + version;
    sha256 = "sha256-JCNpgdV4v0DzRmELAv+UwPAZ7O2V0KI4t8zirhhQshA";
  };

  cargoSha256 = "sha256-wit1rAOH9tIu8SpyXNk0GNuBo17liBw4e+JjPQj+uA4=";

  checkFlags = [
    # direct writing /tmp
    "--skip=models::config::test::test_config_new"
    # with network access when testing
    "--skip=operations::update::test::test_update_repos"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];
  OPENSSL_NO_VENDOR = 1;

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A theme manager for LeftWM";
    homepage = "https://github.com/leftwm/leftwm-theme";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = with maintainers; [
      denperidge
    ];
  };
}
