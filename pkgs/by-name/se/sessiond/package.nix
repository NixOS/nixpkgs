{
  lib,
  stdenv,
  fetchFromTangled,
  linux-pam,
  pkg-config,
  rustPlatform,
  withConsoleKit ? true,
  installShellFiles,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  __structuredAttrs = true;
  pname = "sessiond";
  version = "0.3.0";

  src = fetchFromTangled {
    did = "did:plc:vj3bxta3i3cp26nn46yideoh";
    tag = "${finalAttrs.pname}-v${finalAttrs.version}";
    hash = "sha256-X2ePs10hjZNOcHAJuN4J5KeBQaW24E2jMRq0biNdY3E=";
  };

  cargoHash = "sha256-+ENVyHs4UFsN62rkIau1aXC2RmF3Mqtj6XWeR55rR8w=";

  cargoBuildFlags = [
    "--locked"
    "-p"
    "sessiond"
    "-p"
    "sessionctl"
    "-p"
    "pam"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  buildNoDefaultFeatures = true;
  buildFeatures = lib.optionals withConsoleKit [
    "sessiond/consolekit"
  ];

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    linux-pam
  ];

  postInstall = ''
    mkdir -p $out/lib/security
    mv $out/lib/libpam.so $out/lib/security/pam_sessiond.so
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd sessionctl \
      --bash <($out/bin/sessionctl completions bash) \
      --zsh <($out/bin/sessionctl completions zsh) \
      --fish <($out/bin/sessionctl completions fish) \
      --nushell <($out/bin/sessionctl completions nushell)
  ''
  + lib.optionalString withConsoleKit ''
    install -Dm644 data/dbus-1/system.d/org.freedesktop.ConsoleKit.conf \
      $out/share/dbus-1/system.d/org.freedesktop.ConsoleKit.conf
  '';

  meta = {
    description = "Session management daemon";
    homepage = "https://tangled.org/r0chd.pl/sessiond";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.r0chd ];
    platforms = lib.platforms.linux;
  };
})
