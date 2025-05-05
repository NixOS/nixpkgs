{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "kafkactl";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "deviceinsight";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-wSzLKiu6GqnCoQ5SkMhnh7u8ADUZ9vmVBRW6XRuR5I8=";
  };

  vendorHash = "sha256-VhNwmgKvKFiL6GQlKME0VbJKn8ESTxX5W27xPV4vwu0=";

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
