{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenv,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pietrasanta-traceroute";
  version = "0.1.36-unstable-2026-11-19";

  src = fetchFromGitHub {
    owner = "catchpoint";
    repo = "Pietrasanta-traceroute";
    rev = "f5f2143a0f88c8055eb9c19bc4112514aa85d8ca";
    hash = "sha256-dz/UjW1ciDrMzuntYsEXWvOia3ZDOuV2IQNMEPVAEcA=";
  };
  passthru.updateScript = unstableGitUpdater { };

  buildInputs = [ openssl ];
  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "ECN-aware version of traceroute";
    longDescription = ''
      An enhanced version of Dmitry Butskoy's traceroute, developed by Catchpoint.
      - Support for "TCP InSession": opens a TCP connection with the destination and sends TCP probes with
        increasing TTL values, to prevent false packet loss introduced by firewalls, and ensure packets
        follow a single flow, akin to a normal TCP session.
      - Similar QUIC-based traceroute.
      - Enhanced ToS (DSCP/ECN) field report.
    '';
    homepage = "https://github.com/catchpoint/Pietrasanta-traceroute/";
    changelog = "https://github.com/catchpoint/Pietrasanta-traceroute/blob/${finalAttrs.src.rev}/ChangeLog";
    license = with lib.licenses; [
      gpl2Only
      lgpl21Only
    ];
    mainProgram = "traceroute";
    maintainers = with lib.maintainers; [ nicoo ];
    platforms = lib.platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})
