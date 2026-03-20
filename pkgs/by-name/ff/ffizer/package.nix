{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ffizer";
  version = "2.13.7";

  buildFeatures = [ "cli" ];

  src = fetchFromGitHub {
    owner = "ffizer";
    repo = "ffizer";
    rev = finalAttrs.version;
    hash = "sha256-r4jaqjHYDZxftU7J6hGMXW/Oq+8biy9bFoHIOt33ta8=";
  };

  cargoHash = "sha256-+aXhumywpcynKz0R0wWPWhEMfqiPBuwLbIFsABvWTnA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  env.OPENSSL_NO_VENDOR = true;

  checkFlags = [
    # requires internet access
    "--skip=run_test_samples_tests_data_template_2"
  ];

  meta = {
    description = "Files and folders initializer / generator based on templates";
    homepage = "https://github.com/ffizer/ffizer";
    changelog = "https://github.com/ffizer/ffizer/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ XBagon ];
    mainProgram = "ffizer";
  };
})
