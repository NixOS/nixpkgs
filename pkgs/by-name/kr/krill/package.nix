{
  lib,
  rustPlatform,
  fetchFromGitHub,
  openssl,
  pkg-config,
  stdenv,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "krill";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "krill";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Egy/knMiu+Pglx4v62lPZ87daRKida8W05qu+5yGt1g=";
  };

  cargoHash = "sha256-2wbMcI+zS8e9DfVvVAOHxyuHKWFCls57yt8QRw8JJq0=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkgconfig.
  env.OPENSSL_NO_VENDOR = 1;

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
    changelog = "https://github.com/NLnetLabs/krill/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ steamwalker ];
  };
})
