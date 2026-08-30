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
  version = "0.2.0";

  cargoHash = "sha256-QM5eDBSBahobqsJKFAG9eR/FvYrpVuQ3L1CXmhlIBFY=";

  src = fetchFromTangled {
    did = "did:plc:vj3bxta3i3cp26nn46yideoh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kygJ/Hw/5tBjGCxsRLrti3L1Zcpm8y5gLpGPGsqV0VI=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    linux-pam
  ];

  buildFeatures = lib.optionals withConsoleKit [
    "consolekit"
  ];

  postInstall = ''
    mkdir -p $out/lib/security
    mv $out/lib/libpam.so $out/lib/security/pam_sessiond.so
    mv $out/bin/daemon $out/bin/sessiond
    mv $out/bin/ctl $out/bin/sessionctl
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
    maintainers = builtins.attrValues { inherit (lib.maintainers) r0chd; };
    platforms = lib.platforms.linux;
  };
})
