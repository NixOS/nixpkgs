{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "ffizer";
  version = "2.13.1";

  buildFeatures = [ "cli" ];

  src = fetchFromGitHub {
    owner = "ffizer";
    repo = "ffizer";
    rev = version;
    hash = "sha256-ZX6Zv6ioAO33Cc5WCVBgJWlOmNvbVgckMylRnphpOdw=";
  };

  cargoHash = "sha256-4fZLL4vQxAeyqQssmEd1C72fzMXCGHtUPCGpaVupy6Q=";

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
    changelog = "https://github.com/ffizer/ffizer/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ XBagon ];
    mainProgram = "ffizer";
  };
}
