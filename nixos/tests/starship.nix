import ./make-test-python.nix ({ pkgs, ... }: {
  name = "starship";
  meta.maintainers = pkgs.starship.meta.maintainers;

  nodes.machine = {
    programs = {
      fish.enable = true;
      zsh.enable = true;

      starship = {
        enable = true;
        settings.format = "<starship>";
      };
    };

    environment.systemPackages = map
      (shell: pkgs.writeScriptBin "expect-${shell}" ''
        #!${pkgs.expect}/bin/expect -f

        spawn env TERM=xterm ${shell} -i

        expect "<starship>" {
          send "exit\n"
        } timeout {
          send_user "\n${shell} failed to display Starship\n"
          exit 1
        }

        expect eof
      '')
      [ "bash" "fish" "zsh" ];
  };

  testScript = ''
    start_all()
    machine.wait_for_unit("default.target")

    machine.succeed("expect-bash")
    machine.succeed("expect-fish")
    machine.succeed("expect-zsh")
  '';
})
