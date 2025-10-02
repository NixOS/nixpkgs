{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  stdenv,
}:

rustPlatform.buildRustPackage rec {
  pname = "krill";
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "krill";
    rev = "v${version}";
    hash = "sha256-aYZZuEh9RpxGcZllc7usFrLXV8MD1SGrtnbZI7i1h8I=";
  };

  cargoHash = "sha256-WJqJkcAUJhPy0jbGit/nXmJPCU7dK8I8w3JCmTdzhhA=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkgconfig.
  OPENSSL_NO_VENDOR = 1;

  # disable failing tests on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  meta = {
    description = "RPKI Certificate Authority and Publication Server written in Rust";
    longDescription = ''
      Krill is a free, open source RPKI Certificate Authority that lets you run
      delegated RPKI under one or multiple Regional Internet Registries (RIRs).
      Through its built-in publication server, Krill can publish Route Origin
      Authorisations (ROAs) on your own servers or with a third party.
    '';
    homepage = "https://github.com/NLnetLabs/krill";
    changelog = "https://github.com/NLnetLabs/krill/releases/tag/v${version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ steamwalker ];
  };
}
