{ lib, ... }:
{
  name = "selinux";
  meta.maintainers = with lib.maintainers; [
    RossComputerGuy
    numinit
  ];

  nodes.machine =
    { ... }:
    {
      security.selinux = {
        enable = true;
        policyVersion = 33;
      };
    };

  testScript =
    { nodes, ... }:
    ''
      start_all()
      machine.wait_for_unit("default.target")

      # Ensure the policy versions match
      machine.succeed("policyvers | grep ${toString nodes.machine.security.selinux.policyVersion}");

      # Checks if SELinux is actually enabled
      machine.succeed("selinuxenabled")

      # Checks if we're in the right mode
      machine.succeed("getenforce | tr '[:upper:]' '[:lower:]' | grep ${nodes.machine.security.selinux.mode}");
    '';
}
