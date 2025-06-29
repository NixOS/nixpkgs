{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kafkactl";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = "kafkactl";
    tag = "v${version}";
    hash = "sha256-yoNZD6WiaGtZlJRQJeu6rIDCN2ozVXYTr71PAVpgWIE=";
  };

  vendorHash = "sha256-eGTT3ETww+tR8nuhALy3fbQu3fmRLSLPIEGHHa6TVsE=";

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
