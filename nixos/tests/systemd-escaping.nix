{ pkgs, ... }:

let
  echoAll = pkgs.writeScript "echo-all" ''
    #! ${pkgs.runtimeShell}
    for s in "$@"; do
      printf '%s\n' "$s"
    done
  '';
  # deliberately using a local empty file instead of pkgs.emptyFile to have
  # a non-store path in the test
  args = [
    "a%Nything"
    "lang=\${LANG}"
    ";"
    "/bin/sh -c date"
    ./empty-file
    4.2
    23
  ];
in
{
  name = "systemd-escaping";

  nodes.machine =
    {
      pkgs,
      lib,
      utils,
      ...
    }:
    {
      systemd.services.echo =
        assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ [ ] ])).success;
        assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ { } ])).success;
        assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ null ])).success;
        assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ false ])).success;
        assert !(builtins.tryEval (utils.escapeSystemdExecArgs [ (_: _) ])).success;
        {
          description = "Echo to the journal";
          serviceConfig.Type = "oneshot";
          serviceConfig.ExecStart = ''
            ${echoAll} ${utils.escapeSystemdExecArgs args}
          '';
        };
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("systemctl start echo.service")
    # skip the first 'Starting <service> ...' line
    logs = machine.succeed("journalctl -u echo.service -o cat").splitlines()[1:]
    assert "a%Nything" == logs[0]
    assert "lang=''${LANG}" == logs[1]
    assert ";" == logs[2]
    assert "/bin/sh -c date" == logs[3]
    assert "/nix/store/ij3gw72f4n5z4dz6nnzl1731p9kmjbwr-empty-file" == logs[4]
    assert "4.2" in logs[5] # toString produces extra fractional digits!
    assert "23" == logs[6]
  '';
}
