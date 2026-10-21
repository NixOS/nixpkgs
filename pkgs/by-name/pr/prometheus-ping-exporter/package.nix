{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "ping-exporter";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "czerwonk";
    repo = "ping_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-faMYFo6QdiyLZ5v7BcsIakQ0SD4r6Jb2VQvGuWzjrmI=";
  };

  vendorHash = "sha256-xO+86cajEkPj2+6DtShbPjspDmpb1egm76ok/2V0NMM=";

  meta = {
    description = "Prometheus exporter for ICMP echo requests";
    mainProgram = "ping_exporter";
    homepage = "https://github.com/czerwonk/ping_exporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nudelsalat ];
  };
})
