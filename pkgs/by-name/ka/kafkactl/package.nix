{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kafkactl";
  version = "5.15.0";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = "kafkactl";
    tag = "v${version}";
    hash = "sha256-4Kj5RqnTVfMsjEutxJ+21kT7s4UAd8JSKTuPXQtAnxo=";
  };

  vendorHash = "sha256-sVvEHMXpjas+l93IZfAChDX5eDm0lkUNCr5r1JaVQ9I=";

  doCheck = false;

  meta = {
    homepage = "https://github.com/deviceinsight/kafkactl";
    changelog = "https://github.com/deviceinsight/kafkactl/blob/v${version}/CHANGELOG.md";
    description = "Command Line Tool for managing Apache Kafka";
    mainProgram = "kafkactl";
    longDescription = ''
      A command-line interface for interaction with Apache Kafka.
      Features:
      - command auto-completion for bash, zsh, fish shell including dynamic completion for e.g. topics or consumer groups
      - support for avro schemas
      - Configuration of different contexts
      - directly access kafka clusters inside your kubernetes cluster
    '';
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ grburst ];
  };
}
