{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kaf";
  version = "0.2.11";

  src = fetchFromGitHub {
    owner = "birdayz";
    repo = "kaf";
    rev = "v${version}";
    hash = "sha256-SKQg3BCwvVwjZUkTjrMlSrfa8tu2VC8+ckMZpBJhnZE=";
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
