{ pkgs, ... }:
{
  name = "atuin-default-settings";
  meta.maintainers = pkgs.atuin.meta.maintainers;

  nodes.machine = {
    programs.atuin.enable = true;
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")

    machine.succeed("test -f /etc/atuin/config.toml")
    machine.succeed("bash -lc 'atuin doctor'")
  '';
}
