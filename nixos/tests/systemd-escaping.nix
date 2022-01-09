import ./make-test-python.nix ({ pkgs, ... }:

let
  echoAll = pkgs.writeScript "echo-all" ''
    #! ${pkgs.runtimeShell}
    for s in "$@"; do
      printf '%s\n' "$s"
    done
  '';
  # deliberately using a local empty file instead of pkgs.emptyFile to have
  # a non-store path in the test
  args = [ "a%Nything" "lang=\${LANG}" ";" "/bin/sh -c date" ./empty-file ];
in
{
  name = "systemd-escaping";

  machine = { pkgs, lib, utils, ... }: {
    systemd.services.echo =
      { description = "Echo to the journal";
        serviceConfig.Type = "oneshot";
        serviceConfig.ExecStart = ''
          ${echoAll} ${utils.escapeSystemdExecArgs args}
        '';
      };
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("systemctl start echo.service")
    logs = machine.succeed("journalctl -u echo.service -o cat")
    assert "a%Nything" in logs
    assert "lang=''${LANG}" in logs
    assert ";" in logs
    assert "/bin/sh -c date" in logs
    assert "/nix/store/ij3gw72f4n5z4dz6nnzl1731p9kmjbwr-empty-file" in logs
  '';
})
