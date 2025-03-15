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
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "carthage-software";
    repo = "mago";
    tag = version;
    hash = "sha256-Rx4i4kz5czUyo059Hzd3D4+vfeTDEHTo7L+GBrOr1Uk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-Ws5CjNwWFh3I1Lkiht/jmAz0q8EmTln3WltAly+Xb4I=";

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
      version = "mago-cli ${version}";
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
