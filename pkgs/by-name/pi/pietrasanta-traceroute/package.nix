{
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  stdenv,
  openssl,
}:

stdenv.mkDerivation rec {
  pname = "pietrasanta-traceroute";
  version = "0.0.5-unstable-2024-06-11";

  src = fetchFromGitHub {
    owner = "catchpoint";
    repo = "Networking.traceroute";
    rev = "5b9f9cd2cbd5b8d90442d4ddb71ab788297e2153";
    hash = "sha256-/WsBh42brVCRP31LnCPS34kRaQKMvP+XEENyD5MjCfw=";
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
    broken = stdenv.isDarwin;
  };
}
