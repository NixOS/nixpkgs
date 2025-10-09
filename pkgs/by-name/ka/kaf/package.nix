{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kaf";
  version = "0.2.13";

  src = fetchFromGitHub {
    owner = "birdayz";
    repo = "kaf";
    rev = "v${version}";
    hash = "sha256-tjHRIbTJJ8HPp2Jk7R2rl+ZN+ie6xRlssx4clcGc4U4=";
  };

  vendorHash = "sha256-1QcQeeYQFsStK27NVdyCAb1Y40lyifBf0dlSgzocG3Y=";

  # Many tests require a running Kafka instance
  doCheck = false;

  meta = with lib; {
    description = "Modern CLI for Apache Kafka, written in Go";
    mainProgram = "kaf";
    homepage = "https://github.com/birdayz/kaf";
    license = licenses.asl20;
    maintainers = with maintainers; [ zarelit ];
  };
}
