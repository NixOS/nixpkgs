# Test for NixOS' container nesting.

{
  lib,
  pkgs,
  config,
  ...
}:
let
  system = config.nodes.machine.nixpkgs.hostPlatform.system;
in
{
  options = {
    params.nix = lib.mkOption {
      description = "Whether to enable nix on host and containers - we test both variants";
      type = lib.types.bool;
      default = false; # In line with all-tests.nix / tag(no-nix-by-default)
    };
  };
  config.name = "nested";

  config.meta = with pkgs.lib.maintainers; {
    maintainers = [ sorki ];
  };

  config.nodes.machine =
    { lib, ... }:
    let
      makeNested = subConf: {
        # NOTE: outer container is also called "nested"!
        containers.nested = {
          autoStart = true;
          privateNetwork = true;
          config = {
            imports = [ subConf ];
            nix.enable = config.params.nix;
            nix.settings.substitute = false;
          };
        };
        # host or level 1
        nix.enable = config.params.nix;
      };
    in
    {
      imports = [
        (makeNested (makeNested { }))
      ];
      nix.settings.substitute = false;
    };

  config.testScript = ''
    machine.start()
    machine.wait_for_unit("container@nested.service")
    machine.succeed("systemd-run --pty --machine=nested -- machinectl list | grep nested")
    print(
        machine.succeed(
            "systemd-run --pty --machine=nested -- systemd-run --pty --machine=nested -- systemctl status"
        )
    )

    ${lib.optionalString config.params.nix ''
      def check_path(path):
          # result is available on host
          machine.succeed(f"""
            stat {path}
          """)
          # result is available on container
          # invocation by absolute path because systemd-run is quite minimal
          machine.succeed(f"""
            systemd-run --machine=nested --pipe --wait -- /run/current-system/sw/bin/stat {path}
          """)
          # result is available on nested container
          machine.succeed(f"""
            systemd-run --machine=nested --pipe --wait  -- systemd-run --machine=nested --pipe --wait -- /run/current-system/sw/bin/stat {path}
          """)

      with subtest("nix store sharing"):
          with subtest("built on host"):
              build = machine.succeed("""
                nix-build --expr 'derivation {
                  name = "buildprobe-0";
                  system = "${system}";
                  builder = "/bin/sh";
                  args = [ "-c" "echo ok 0 >$out" ];
                }'
              """)
              check_path(build)

          with subtest("built on container layer 1"):
              build = machine.succeed("""
                systemd-run --machine=nested --pipe --wait -- \
                  /bin/sh -l -c 'exec $0 "$@"' \
                  /run/current-system/sw/bin/nix-build --expr 'derivation {
                    name = "buildprobe-1";
                    system = "${system}";
                    builder = "/bin/sh";
                    args = [ "-c" "echo ok 1 >$out" ];
                  }'
              """)
              check_path(build)

          with subtest("built on container layer 2"):
              build = machine.succeed("""
                systemd-run --machine=nested --pipe --wait -- \
                  systemd-run --machine=nested --pipe --wait -- \
                  /bin/sh -l -c 'exec $0 "$@"' \
                  /run/current-system/sw/bin/nix-build --expr 'derivation {
                    name = "buildprobe-2";
                    system = "${system}";
                    builder = "/bin/sh";
                    args = [ "-c" "echo ok 2 >$out" ];
                  }'
              """)
              check_path(build)

    ''}
  '';
}
