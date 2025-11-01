{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rkik";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "aguacero7";
    repo = "rkik";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bT1WTs/gei8CGundLynVgekNFlyY8p/mK73Utrw8N9I=";
  };

  cargoHash = "sha256-iu9vADHhems0pzQ0Hs+Zp0dZ4K185M5L4fftBaAZdvE=";

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
