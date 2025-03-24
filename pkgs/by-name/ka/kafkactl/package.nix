{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kafkactl";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-hhFQbs7p3j8y845asZt6c+OcZ6WgpoTBttGG5IwT7Kc=";
  };

  vendorHash = "sha256-0Kc8Z32YdmwhKMTBMBAK0ZdnXnH8/Ze1HcMDafosLvw=";

  doCheck = false;

  meta = with lib; {
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
    license = licenses.asl20;
    maintainers = with maintainers; [ grburst ];
  };
}
