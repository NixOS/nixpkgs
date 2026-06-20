{ pkgs, lib, ... }:
{
  name = "age-plugin-tpm-decrypt";
  meta = with lib.maintainers; {
    maintainers = [
      sgo
      josh
    ];
  };

  nodes.machine =
    { pkgs, ... }:
    {
      virtualisation.tpm.enable = true;
      environment.systemPackages = with pkgs; [
        age
        age-plugin-tpm
      ];
    };

  testScript = ''
    machine.start()

    machine.succeed("age-plugin-tpm --generate --output identity.txt")
    machine.succeed("age-plugin-tpm --convert identity.txt --output recipient.txt")
    machine.succeed("echo -n 'Hello World' >data.txt")

    machine.succeed("age --encrypt --recipients-file recipient.txt --output data.age data.txt")
    data = machine.succeed("age --decrypt --identity identity.txt data.age")

    assert data == "Hello World"
  '';
}
