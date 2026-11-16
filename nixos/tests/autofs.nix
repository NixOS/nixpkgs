{ lib, pkgs, ... }:
let
  sourceDir = "/srv/autofs-source";
  mountBase = "/auto";
  mountName = "share";
  fileName = "hello.txt";
  fileContent = "Hello from autofs test!";
in
{
  name = "autofs";
  meta.maintainers = [ lib.maintainers.h7x4 ];

  nodes.machine = {
    systemd.tmpfiles.settings."10-autofs-test" = {
      ${sourceDir}.d.mode = "0755";
      "${sourceDir}/${fileName}".f = {
        mode = "0644";
        argument = fileContent;
      };
    };

    services.autofs = {
      enable = true;
      debug = true;
      autoMaster = ''
        ${mountBase} file:${pkgs.writeText "auto.share" ''
          ${mountName} -fstype=bind :${sourceDir}
        ''}
      '';
    };
  };

  testScript = ''
    machine.wait_for_unit("autofs.service")
    assert "${fileContent}" in machine.succeed("cat ${mountBase}/${mountName}/${fileName}")
    machine.wait_until_succeeds(
        "journalctl --grep 'mounted ${sourceDir} type bind on ${mountBase}/${mountName}'"
    )
  '';
}
