{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  protobuf,
  libsodium,
  openssl,
  xz,
  zeromq,
  cacert,
}:

rustPlatform.buildRustPackage rec {
  pname = "habitat";
  version = "1.6.848";

  src = fetchFromGitHub {
    owner = "habitat-sh";
    repo = "habitat";
    rev = version;
    hash = "sha256-oK9ZzENwpEq6W1qnhSgkr7Rhy7Fxt/BS4U5nxecyPu8=";
  };

  cargoPatches = [
    (fetchpatch {
      name = "remove-yanked-env-crate.patch";
      url = "https://github.com/habitat-sh/habitat/commit/27f3fa5e5baa611b2459a86f5ac37ab2363a0db8.patch";
      hash = "sha256-mOZW5tDv4/C0+fPXBSXaL/IgOO30cJbGwiiGxutyIb4=";
    })
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-6gBqGzIE8re0v4YX+x0rqSK1O7ZgE1hJnHbDmUp+xjE=";

  nativeBuildInputs = [
    pkg-config
    protobuf
  ];

  buildInputs = [
    libsodium
    openssl
    xz
    zeromq
  ];

  cargoBuildFlags = [
    "-p"
    "hab"
  ];
  cargoTestFlags = cargoBuildFlags;

  env = {
    OPENSSL_NO_VENDOR = true;
    SODIUM_USE_PKG_CONFIG = true;
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  meta = with lib; {
    description = "Application automation framework";
    homepage = "https://www.habitat.sh";
    changelog = "https://github.com/habitat-sh/habitat/blob/${src.rev}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [
      rushmorem
      qjoly
    ];
    mainProgram = "hab";
    platforms = [ "x86_64-linux" ];
  };
}
