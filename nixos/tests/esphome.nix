{ pkgs, lib, ... }:

let
  testPort = 6052;
  remoteBuildPort = 6055;
  unixSocket = "/run/esphome/esphome.sock";

  # Stands in for the toolchains ESPHome downloads: built for generic Linux,
  # with the standard loader path and no RPATH.
  genericElf =
    pkgs.runCommandCC "generic-linux-elf"
      {
        nativeBuildInputs = [ pkgs.patchelf ];
        buildInputs = [ pkgs.zlib ];
      }
      ''
        mkdir -p $out/bin
        cat > hello.c <<'C'
        #include <stdio.h>
        #include <zlib.h>
        int main(void) { printf("generic-linux-ok zlib %s\n", zlibVersion()); return 0; }
        C
        $CC hello.c -lz -o $out/bin/generic-hello
        patchelf $out/bin/generic-hello \
          --set-interpreter $(cat ${pkgs.nix-ld}/nix-support/ldpath) \
          --remove-rpath
      '';
in
{
  name = "esphome";
  meta.maintainers = with lib.maintainers; [
    oddlama
    tmarkus
  ];

  nodes = {
    esphomeTcp =
      { ... }:
      {
        services.esphome = {
          enable = true;
          port = testPort;
          address = "0.0.0.0";
          openFirewall = true;
        };
      };

    esphomeUnix =
      { ... }:
      {
        services.esphome = {
          enable = true;
          enableUnixSocket = true;
          nix-ld.enable = false;
        };
      };

    esphomeRemoteBuild =
      { ... }:
      {
        services.esphome = {
          enable = true;
          remoteBuildOnly = true;
          inherit remoteBuildPort;
          openFirewall = true;
        };
      };

    esphomeNixLd =
      { config, ... }:
      {
        services.esphome.enable = true;

        # Runs the ELF with the esphome unit's mounts, environment and
        # hardening (seccomp filter, MemoryDenyWriteExecute, no capabilities).
        systemd.services.esphome-probe = {
          inherit (config.systemd.services.esphome) path;
          environment = removeAttrs config.systemd.services.esphome.environment [ "PATH" ];
          serviceConfig = config.systemd.services.esphome.serviceConfig // {
            Type = "oneshot";
            ExecStart = "${genericElf}/bin/generic-hello";
            Restart = "no";
          };
        };
      };
  };

  testScript = ''
    import shlex

    esphomeTcp.wait_for_unit("esphome.service")
    esphomeTcp.wait_for_open_port(${toString testPort})
    esphomeTcp.succeed("curl --fail http://localhost:${toString testPort}/")

    esphomeUnix.wait_for_unit("esphome.service")
    esphomeUnix.wait_for_file("${unixSocket}")
    esphomeUnix.succeed("curl --fail --unix-socket ${unixSocket} http://localhost/")

    esphomeRemoteBuild.wait_for_unit("esphome.service")
    esphomeRemoteBuild.wait_for_open_port(${toString remoteBuildPort})

    probe = "${genericElf}/bin/generic-hello"
    stub_ld_message = "NixOS cannot run dynamically linked executables"

    def unit_pid(machine):
        return machine.succeed("systemctl show -P MainPID esphome.service").strip()

    def in_esphome_unit(machine, command):
        pid = unit_pid(machine)
        unit_env = machine.succeed(f"tr '\\0' '\\n' < /proc/{pid}/environ").splitlines()
        env = " ".join(shlex.quote(entry) for entry in unit_env)
        return (
            f"nsenter --target {pid} --mount --setuid $(id -u esphome) --setgid $(id -g esphome) -- "
            f"env -i {env} {command}"
        )

    esphomeNixLd.wait_for_unit("esphome.service")

    with subtest("nix-ld runs a generic Linux ELF with the esphome unit's hardening"):
        esphomeNixLd.succeed("systemctl start esphome-probe.service")
        output = esphomeNixLd.succeed("journalctl -o cat -u esphome-probe.service")
        assert "generic-linux-ok zlib" in output, output

    with subtest("nix-ld runs a generic Linux ELF inside the running esphome unit"):
        output = esphomeNixLd.succeed(in_esphome_unit(esphomeNixLd, probe))
        assert "generic-linux-ok zlib" in output, output

    with subtest("the rest of the system keeps stub-ld"):
        output = esphomeNixLd.fail(f"{probe} 2>&1")
        assert stub_ld_message in output, output
        output = esphomeNixLd.fail(f"systemd-run --wait --pipe {probe} 2>&1")
        assert stub_ld_message in output, output

    with subtest("the esphome unit sees the same stub-ld store path as the host"):
        stub_ld = esphomeNixLd.succeed("readlink -f $(cat ${pkgs.nix-ld}/nix-support/ldpath)").strip()
        host_sum = esphomeNixLd.succeed(f"sha256sum {stub_ld}")
        unit_sum = esphomeNixLd.succeed(
            f"nsenter --target {unit_pid(esphomeNixLd)} --mount sha256sum {stub_ld}"
        )
        assert host_sum == unit_sum, f"{host_sum} != {unit_sum}"

    with subtest("sh resolves on the esphome unit's PATH"):
        esphomeNixLd.succeed(in_esphome_unit(esphomeNixLd, "sh -c true"))

    with subtest("with nix-ld.enable = false the esphome unit keeps stub-ld"):
        output = esphomeUnix.fail(in_esphome_unit(esphomeUnix, f"{probe} 2>&1"))
        assert stub_ld_message in output, output
  '';
}
