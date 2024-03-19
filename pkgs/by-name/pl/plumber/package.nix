{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "plumber";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "streamdal";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-H1tyMedYKj1bePNcaEWYP3njHw57cJ0jgxwC7zDXQvk=";
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
    mainProgram = "plumber";
    homepage = "https://github.com/streamdal/plumber";
    license = licenses.mit;
    maintainers = with maintainers; [ svrana ];
  };
}
