{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  openssl,
  pkg-config,
  stdenv,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "krill";
  version = "0.16.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NLnetLabs";
    repo = "krill";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iNDZAMQPsK1+agQDv0TLyPqwt9zoi/Oi1c+BkZGppXs=";
  };

  cargoHash = "sha256-pf5Bu4XGpbnTeRjD03d5/UDejhlGF85I3wChwM4YhmM=";

  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  # Needed to get openssl-sys to use pkgconfig.
  env.OPENSSL_NO_VENDOR = 1;

  # disable failing tests on darwin
  doCheck = !stdenv.hostPlatform.isDarwin;

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.tests = { inherit (nixosTests) krill; };

  meta = {
    mainProgram = "krillc";
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
    maintainers = with lib.maintainers; [ stepbrobd ];
    teams = [ lib.teams.ngi ];
  };
})
