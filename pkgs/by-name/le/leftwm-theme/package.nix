{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage {
  pname = "leftwm-theme";
  version = "unstable-2024-03-05";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm-theme";
    rev = "b394824ff874b269a90c29e2d45b0cacc4d209f5";
    hash = "sha256-cV4tY1qKNluSSGf+WwKFK3iVE7cMevafl6qQvhy1flE=";
  };

  cargoHash = "sha256-v3PHMaXJCEBiCd+78b/BXRooZC4Py82gDcvA/efNJ7w=";

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
    description = "Theme manager for LeftWM";
    homepage = "https://github.com/leftwm/leftwm-theme";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ denperidge ];
  };
}
