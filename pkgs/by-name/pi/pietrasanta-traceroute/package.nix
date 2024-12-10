{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenv,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "pietrasanta-traceroute";
  version = "0.0.5-unstable-2023-11-28";

  src = fetchFromGitHub {
    owner = "catchpoint";
    repo = "Networking.traceroute";
    rev = "c870c7bd7bafeab815f8564a67a281892c3a6230";
    hash = "sha256-CKqm8b6qNLEpso25+uTvtiR/hFMKJzuXUZkQ7lWzGd8=";
  };
  passthru.updateScript = unstableGitUpdater { };

  buildInputs = [ openssl ];
  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    description = "ECN-aware version of traceroute";
    longDescription = ''
      An enhanced version of Dmitry Butskoy's traceroute, developed by Catchpoint.
      - Support for "TCP InSession": opens a TCP connection with the destination and sends TCP probes with
        increasing TTL values, to prevent false packet loss introduced by firewalls, and ensure packets
        follow a single flow, akin to a normal TCP session.
      - Similar QUIC-based traceroute.
      - Enhanced ToS (DSCP/ECN) field report.
    '';
    homepage = "https://github.com/catchpoint/Networking.traceroute/";
    changelog = "https://github.com/catchpoint/Networking.traceroute/blob/${src.rev}/ChangeLog";
    license = with licenses; [
      gpl2Only
      lgpl21Only
    ];
    mainProgram = "traceroute";
    maintainers = with maintainers; [ nicoo ];
    platforms = platforms.all;
  };
}
