{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "plumber";
  version = "2.5.4";

  src = fetchFromGitHub {
    owner = "streamdal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6nPH+HQtpFJ4MAtblFWjaQjDSKtpIxW9tGt2o1ICtos=";
  };

  vendorHash = null;

  # connection tests create a config file in user home directory
  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/streamdal/plumber/options.VERSION=${version}"
  ];

  meta = with lib; {
    description = "A CLI devtool for interacting with data in message systems like Kafka, RabbitMQ, GCP PubSub and more";
    homepage = "https://github.com/streamdal/plumber";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
  };
}
