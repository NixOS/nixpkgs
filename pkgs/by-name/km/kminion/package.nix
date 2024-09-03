{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "kafka-minion";
  version = "2.2.7";

  src = fetchFromGitHub {
    owner = "redpanda-data";
    repo = "kminion";
    rev = "0c90d4301ed4600d1aaf3345b6f16587d2f282fc";
    hash = "sha256-CWjX46Sfc9Xj+R7+CZeMuTY0iUStzyZXI4FotwqR44M=";
  };

  vendorHash = "sha256-6yfQVoY/bHMA4s0IN5ltnQdHWnE3kIKza36uEcGa11U=";

  doCheck = false;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "KMinion is a feature-rich Prometheus exporter for Apache Kafka written in Go";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ cafkafk ];
    mainProgram = "kminion";
  };
}
