{ lib
, buildGoModule
, fetchFromGitHub
, nixosTests
}:

buildGoModule rec {
  pname = "prometheus-kafka-adapter";
  version = "1.9.0";

  src = fetchFromGitHub {
    owner = "Telefonica";
    repo = "prometheus-kafka-adapter";
    rev = version;
    hash = "sha256-nL6NSLG2POgnIvaQ7JWahKCnnOh3/ZatM22kxZ6CNTQ=";
  };

  vendorHash = null;

  meta = with lib; {
    description = "Prometheus remote write adapter for Apache Kafka";
    homepage = "https://github.com/Telefonica/prometheus-kafka-adapter";
    changelog = "https://github.com/Telefonica/prometheus-kafka-adapter/releases/tag/${src.rev}";
    license = licenses.asl20;
    maintainers = with maintainers; [ illustris ];
    mainProgram = pname;
    platforms = [ "x86_64-linux" ];
  };
}
