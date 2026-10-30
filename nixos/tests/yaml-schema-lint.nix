{ pkgs, ... }:

{
  name = "yaml-schema-lint";
  meta = {
    inherit (pkgs.yaml-schema-lint.meta) maintainers;
  };

  # Containers can easily be run in virtualised environments, e.g., CI systems
  # and VM features are not required to test a CLI tool
  containers.machine =
    { pkgs, ... }:
    {
      users.users.alice = {
        isNormalUser = true;
        packages = [ pkgs.yaml-schema-lint ];
      };
    };

  testScript =
    { containers }:
    let
      schema = pkgs.writeText "schema.yaml" ''
        type: object
        properties:
          name:
            type: string
        required:
          - name
      '';
      validYaml = pkgs.writeText "valid.yaml" ''
        # yaml-language-server: $schema=./schema.yaml
        name: "test"
      '';
      invalidYaml = pkgs.writeText "invalid.yaml" ''
        # yaml-language-server: $schema=./schema.yaml
        name: 1
      '';
      user = containers.machine.users.users.alice;
      schemaPath = "${user.home}/schema.yaml";
      validYamlPath = "${user.home}/valid.yaml";
      invalidYamlPath = "${user.home}/invalid.yaml";
    in
    ''
      machine.start()

      machine.succeed("su -- alice -c 'which yaml-schema-lint'")

      machine.copy_from_host("${schema}", "${schemaPath}")
      machine.copy_from_host("${validYaml}", "${validYamlPath}")
      machine.copy_from_host("${invalidYaml}", "${invalidYamlPath}")

      with subtest("valid schema"):
          machine.succeed(
              "su -- alice -c 'yaml-schema-lint --no-schema-store ${validYamlPath}'"
          )

      with subtest("invalid schema"):
          machine.fail(
              "su -- alice -c 'yaml-schema-lint --no-schema-store ${invalidYamlPath}'"
          )
    '';
}
