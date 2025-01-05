import ./make-test-python.nix (
  { pkgs, lib, ... }:
  let
    secret-key = "key-name:/COlMSRbehSh6YSruJWjL+R0JXQUKuPEn96fIb+pLokEJUjcK/2Gv8Ai96D7JGay5gDeUTx5wdpPgNvum9YtwA==";
    public-key = "key-name:BCVI3Cv9hr/AIveg+yRmsuYA3lE8ecHaT4Db7pvWLcA=";
  in
  {
    name = "nixseparatedebuginfod";
    # A binary cache with debug info and source for nix
    nodes.cache =
      { pkgs, ... }:
      {
        services.nix-serve = {
          enable = true;
          secretKeyFile = builtins.toFile "secret-key" secret-key;
          openFirewall = true;
        };
        system.extraDependencies = [
          pkgs.nix.debug
          pkgs.nix.src
          pkgs.sl
        ];
      };
    # the machine where we need the debuginfo
    nodes.machine = {
      imports = [
        ../modules/installer/cd-dvd/channel.nix
      ];
      services.nixseparatedebuginfod.enable = true;
      nix.settings = {
        substituters = lib.mkForce [ "http://cache:5000" ];
        trusted-public-keys = [ public-key ];
      };
      environment.systemPackages = [
        pkgs.valgrind
        pkgs.gdb
        (pkgs.writeShellScriptBin "wait_for_indexation" ''
          set -x
          while debuginfod-find debuginfo /run/current-system/sw/bin/nix |& grep 'File too large'; do
            sleep 1;
          done
        '')
      ];
    };
    testScript = ''
      start_all()
      cache.wait_for_unit("nix-serve.service")
      cache.wait_for_open_port(5000)
      machine.wait_for_unit("nixseparatedebuginfod.service")
      machine.wait_for_open_port(1949)

      with subtest("show the config to debug the test"):
        machine.succeed("nix --extra-experimental-features nix-command show-config |& logger")
        machine.succeed("cat /etc/nix/nix.conf |& logger")
      with subtest("check that the binary cache works"):
        machine.succeed("nix-store -r ${pkgs.sl}")

      # nixseparatedebuginfod needs .drv to associate executable -> source
      # on regular systems this would be provided by nixos-rebuild
      machine.succeed("nix-instantiate '<nixpkgs>' -A nix")

      machine.succeed("timeout 600 wait_for_indexation")

      # test debuginfod-find
      machine.succeed("debuginfod-find debuginfo /run/current-system/sw/bin/nix")

      # test that gdb can fetch source
      out = machine.succeed("gdb /run/current-system/sw/bin/nix --batch -x ${builtins.toFile "commands" ''
        start
        l
      ''}")
      print(out)
      assert 'int main(' in out

      # test that valgrind can display location information
      # this relies on the fact that valgrind complains about nix
      # libgc helps in this regard, and we also ask valgrind to show leak kinds
      # which are usually false positives.
      out = machine.succeed("valgrind --leak-check=full --show-leak-kinds=all nix-env --version 2>&1")
      print(out)
      assert 'main.cc' in out
    '';
  }
)
