# Imperative flake containers: `nixos-container create --flake` and `update`,
# including two updates that overlap in one working directory.
#
# The containers' flakes are stubs. nixos-container reads only lib.version,
# config.boot.isNspawnContainer and config.system.build.toplevel from them, so
# naming each toplevel after its container shows which system a profile got.
{ lib, pkgs, ... }:
let
  stubFlake = pkgs.writeText "flake.nix" ''
    {
      outputs = { self }: {
        nixosConfigurations.container = {
          lib.version = "${lib.trivial.release}";
          config.boot.isNspawnContainer = true;
          config.system.build.toplevel = derivation {
            name = "system-@NAME@-@GEN@";
            system = "${pkgs.stdenv.hostPlatform.system}";
            builder = "/bin/sh";
            args = [ "-c" "@BUILD@ > $out" ];
          };
        };
      };
    }
  '';
in
{
  name = "containers-flake-update";

  nodes.machine =
    { config, pkgs, ... }:
    {
      boot.enableContainers = true;

      nix.enable = true; # disabled by default. See all-tests.nix / tag(no-nix-by-default)
      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        # As in containers-imperative: setting up the sandbox fails while
        # hardlinking from the host's store into the chroot. The stub
        # toplevels are built with /bin/sh.
        sandbox = false;
        substituters = [ ];
        flake-registry = "";
      };

      # Rooted by the system, so the garbage collection subtest keeps it.
      environment.etc."stub-flake.nix".source = stubFlake;

      # Put in front of nix on PATH. When $HOLD_AFTER_BUILD names a file,
      # it waits after `nix build` returns until that file exists, so the
      # test decides when a nixos-container run continues past its build.
      # It creates "$HOLD_AFTER_BUILD.held" once it is waiting.
      environment.etc."hold-nix/nix".source = pkgs.writeShellScript "nix" ''
        if [ "$1" = build ]; then
          ${lib.getExe config.nix.package} "$@"
          rc=$?
          if [ -n "''${HOLD_AFTER_BUILD:-}" ]; then
            ${pkgs.coreutils}/bin/touch "$HOLD_AFTER_BUILD.held"
            while [ ! -e "$HOLD_AFTER_BUILD" ]; do ${pkgs.coreutils}/bin/sleep 0.1; done
          fi
          exit $rc
        fi
        exec ${lib.getExe config.nix.package} "$@"
      '';
    };

  testScript = ''
    import shlex

    def write_flake(name, gen, build=None):
        build = build or f"echo {name} {gen}"
        d = f"/root/flakes/{name}"
        machine.succeed(
            f"mkdir -p {d} && rm -f {d}/flake.lock && "
            f"sed -e s/@NAME@/{name}/g -e s/@GEN@/{gen}/g -e {shlex.quote('s/@BUILD@/' + build + '/g')} "
            f"/etc/stub-flake.nix > {d}/flake.nix"
        )

    def profile(name):
        return machine.succeed(f"readlink -f /nix/var/nix/profiles/per-container/{name}/system").strip()

    def start_nixos_container(unit, args, cwd, hold=""):
        machine.succeed(
            f"mkdir -p {cwd}; systemd-run --no-block --unit={unit} --working-directory={cwd} "
            f"--setenv=PATH=/etc/hold-nix:/run/current-system/sw/bin --setenv=HOLD_AFTER_BUILD={hold} "
            f"--property=Type=oneshot --property=RemainAfterExit=yes nixos-container {args}"
        )

    def fails_with(command, message):
        status, output = machine.execute(f"cd /root && {command} 2>&1")
        assert status != 0 and message in output, f"{command}: status {status}\n{output}"

    def result_of(unit):
        machine.wait_until_succeeds(
            f"[ \"$(systemctl show -P ActiveState {unit})\" != activating ]", timeout=120
        )
        return machine.succeed(f"systemctl show -P Result {unit}").strip()

    machine.wait_for_unit("multi-user.target")

    with subtest("create builds into the profile and leaves nothing in the working directory"):
        for name in ["a", "b"]:
            write_flake(name, 1)
            machine.succeed(f"mkdir -p /root/create && cd /root/create && nixos-container create {name} --flake path:/root/flakes/{name}#container")
            assert f"system-{name}-1" in profile(name), profile(name)
        machine.succeed("[ -z \"$(ls -A /root/create)\" ]")

    with subtest("concurrent updates in one working directory keep their own systems"):
        write_flake("a", 2)
        write_flake("b", 2)
        # a finishes its build and is held; b runs start to finish in the same
        # directory; then a continues. Each profile must end up with its own
        # system.
        start_nixos_container("update-a", "update a", "/root/shared", hold="/root/release-a")
        machine.wait_for_file("/root/release-a.held")
        start_nixos_container("update-b", "update b", "/root/shared")
        assert result_of("update-b") == "success"
        machine.succeed("touch /root/release-a")
        assert result_of("update-a") == "success"
        assert "system-a-2" in profile("a"), profile("a")
        assert "system-b-2" in profile("b"), profile("b")
        machine.succeed("[ -z \"$(ls -A /root/shared)\" ]")

    with subtest("a failed update keeps the old profile; a failed create leaves no container"):
        write_flake("a", 3, build="false")
        fails_with("nixos-container update a", "failed to build container from flake")
        assert "system-a-2" in profile("a"), profile("a")
        write_flake("c", 1, build="false")
        fails_with("nixos-container create c --flake path:/root/flakes/c#container", "failed to build container from flake")
        machine.fail("test -e /etc/nixos-containers/c.conf")
        machine.fail("test -e /nix/var/nix/profiles/per-container/c")

    with subtest("garbage collection keeps each container's system, during and after an update"):
        # Control: a build nothing roots is collected.
        write_flake("z", 1)
        machine.succeed("nix build --no-link path:/root/flakes/z#nixosConfigurations.container.config.system.build.toplevel")
        machine.succeed("nix-collect-garbage")
        machine.fail("ls -d /nix/store/*-system-z-1")

        write_flake("a", 4)
        # Collect while the update is held just after its build, then again
        # once it has finished.
        start_nixos_container("gc-update-a", "update a", "/root/gc", hold="/root/release-gc")
        machine.wait_for_file("/root/release-gc.held")
        machine.succeed("nix-collect-garbage")
        machine.succeed("ls -d /nix/store/*-system-a-4")
        machine.succeed("touch /root/release-gc")
        assert result_of("gc-update-a") == "success"
        machine.succeed("nix-collect-garbage")
        assert "system-a-4" in profile("a"), profile("a")
        for name in ["a", "b"]:
            machine.succeed(f"test -e {profile(name)}")

    with subtest("--flake together with --system-path is refused"):
        fails_with(
            "nixos-container create d --flake path:/root/flakes/b#container --system-path /run/current-system",
            "--flake and --system-path are mutually incompatible",
        )
        machine.fail("test -e /etc/nixos-containers/d.conf")
  '';
}
