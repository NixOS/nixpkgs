{
  lib,
  rustPlatform,
  fetchCrate,
  installShellFiles,
  testers,
  sigi,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sigi";
  version = "3.8.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-O/M0NBES215xLwktgOTVIKeXpDXQHDJcJKV3ej5ILEw=";
  };

  cargoHash = "sha256-0jB/eMXEMNEapqwSeFD6aHsYhzHTEYxL3usFrCCZ4uI=";
  nativeBuildInputs = [ installShellFiles ];

  # In case anything goes wrong.
  checkFlags = [ "RUST_BACKTRACE=1" ];

  postInstall = ''
    installManPage sigi.1
  '';

  passthru.tests.version = testers.testVersion { package = sigi; };

  meta = {
    description = "Organizing CLI for people who don't love organizing";
    homepage = "https://github.com/so-dang-cool/sigi";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ booniepepper ];
    mainProgram = "sigi";
  };
})
