{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  testers,
  mago,
}:

rustPlatform.buildRustPackage rec {
  pname = "mago";
  version = "0.23.0";

  src = fetchFromGitHub {
    owner = "carthage-software";
    repo = "mago";
    tag = version;
    hash = "sha256-Kdktcq3czn6YdGKoTB7AjCtfDkNTHhee/kVhMzxsuD8=";
  };

  cargoHash = "sha256-V7x0n+JcXiSGg8sJBKnsB5/KnfJSadYH0i/dNouhoHc=";

  env = {
    # Get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru = {
    tests.version = testers.testVersion {
      package = mago;
      command = "mago --version";
      version = "mago ${version}";
    };
  };

  meta = {
    changelog = "https://github.com/carthage-software/mago/releases/tag/${version}";
    description = "Toolchain for PHP that aims to provide a set of tools to help developers write better code";
    homepage = "https://github.com/carthage-software/mago";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "mago";
  };
}
