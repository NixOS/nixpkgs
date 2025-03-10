import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    user = "alice";
  in
  {
    name = "benchexec";

    nodes.benchexec = {
      imports = [ ./common/user-account.nix ];

      programs.benchexec = {
        enable = true;
        users = [ user ];
      };
    };

    testScript =
      { ... }:
      let
        runexec = lib.getExe' pkgs.benchexec "runexec";
        echo = builtins.toString pkgs.benchexec;
        test = lib.getExe (
          pkgs.writeShellApplication rec {
            name = "test";
            meta.mainProgram = name;
            text = "echo '${echo}'";
          }
        );
        wd = "/tmp";
        stdout = "${wd}/runexec.out";
        stderr = "${wd}/runexec.err";
      in
      ''
        start_all()
        machine.wait_for_unit("multi-user.target")
        benchexec.succeed(''''\
            systemd-run \
              --property='StandardOutput=file:${stdout}' \
              --property='StandardError=file:${stderr}' \
              --unit=runexec --wait --user --machine='${user}@' \
              --working-directory ${wd} \
            '${runexec}' \
              --debug \
              --read-only-dir / \
              --hidden-dir /home \
              '${test}' \
        '''')
        benchexec.succeed("grep -s '${echo}' ${wd}/output.log")
        benchexec.succeed("test \"$(grep -Ec '((start|wall|cpu)time|memory)=' ${stdout})\" = 4")
        benchexec.succeed("! grep -E '(WARNING|ERROR)' ${stderr}")
      '';

    interactive.nodes.benchexec.services.kmscon = {
      enable = true;
      fonts = [
        {
          name = "Fira Code";
          package = pkgs.fira-code;
        }
      ];
    };
  }
)
