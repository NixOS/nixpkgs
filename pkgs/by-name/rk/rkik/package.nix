{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rkik";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "aguacero7";
    repo = "rkik";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LOUEP9wMbc6i3qw9Vv798SUuc3/JwFbRiRns5TZT6b0=";
  };

  cargoHash = "sha256-mfnn+BQ2/k1e2YSZ2eebzbF6Ptz05GSrx83Aa+iaoj4=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Command-line tool for querying NTP servers and comparing clock offsets";
    longDescription = ''
      Most systems rely on a daemon (like chronyd or ntpd) to
      synchronize time. But what if you just want to inspect the
      current offset between your system clock and one or more NTP
      servers — without root, without sync, and without installing
      anything heavyweight?

      RKIK is a Rust-based CLI tool designed for stateless and passive
      NTP inspection, just as dig or ping are for DNS and ICMP.
    '';
    homepage = "https://github.com/aguacero7/rkik";
    changelog = "https://github.com/aguacero7/rkik/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "rkik";
  };
})
