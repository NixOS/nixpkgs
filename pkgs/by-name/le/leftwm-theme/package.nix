{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "leftwm-theme";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "leftwm";
    repo = "leftwm-theme";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TPzmopH9RBM/BBrEL9/NWO3qjVa6SSWCp34tHxjLtBI=";
  };

  cargoHash = "sha256-ZfNVpepTm6/JgJJB+qDVI2gVz36PRBpUL8/ba20xQhk=";

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
})
