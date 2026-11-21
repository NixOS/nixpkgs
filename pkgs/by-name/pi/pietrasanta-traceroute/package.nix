{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenv,
  openssl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pietrasanta-traceroute";
  version = "0.1.36-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "catchpoint";
    repo = "Pietrasanta-traceroute";
    rev = "2ec4344a25ae9263a84c14d1370f85d82f4d96a5";
    hash = "sha256-AJvRGlhs4MZt01SVwJcD/0QhGXJG743Jc8ZqZQEbGeI=";
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
