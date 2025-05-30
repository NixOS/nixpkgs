{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "plumber";
  version = "2.9.0";

  src = fetchFromGitHub {
    owner = "streamdal";
    repo = "plumber";
    rev = "v${version}";
    hash = "sha256-0pyeCTkmS7gG51Xm4Gc62p+I5DRUA2F9tPHaZjO+/WE=";
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
    description = "CLI devtool for interacting with data in message systems like Kafka, RabbitMQ, GCP PubSub and more";
    mainProgram = "plumber";
    homepage = "https://github.com/streamdal/plumber";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
  };
}
