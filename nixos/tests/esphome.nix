{ pkgs, lib, ... }:

let
  testPort = 6052;
  remoteBuildPort = 6055;
  unixSocket = "/run/esphome/esphome.sock";

  # Stands in for the toolchains ESPHome downloads: built for generic Linux,
  # with the FHS loader path and no RPATH.
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
          --set-interpreter /${pkgs.stdenv.hostPlatform.libDir}/${baseNameOf pkgs.stdenv.cc.bintools.dynamicLinker} \
          --remove-rpath
      '';

  # The FHS env esphome runs in, with a probe in place of the esphome CLI.
  esphomeFHSProbe = pkgs.buildFHSEnv {
    name = "esphome-fhs-probe";
    inherit (pkgs.esphome.args) targetPkgs;
    runScript = pkgs.writeShellScript "esphome-fhs-probe" ''
      set -eu
      # ESP-IDF builds run ninja, which in nixpkgs spawns `sh` from PATH.
      command -v sh
      exec ${genericElf}/bin/generic-hello
    '';
  };
in
{
  name = "esphome";
  meta.maintainers = with lib.maintainers; [
    oddlama
    AAAAAASomeThingsFailToEvaluate
  ];

  nodes = {
    esphomeTcp =
      { config, ... }:
      {
        services.esphome = {
          enable = true;
          port = testPort;
          address = "0.0.0.0";
          openFirewall = true;
        };

        # Runs the esphome CLI and the probe with the esphome unit's mounts,
        # environment and hardening (seccomp filter, MemoryDenyWriteExecute,
        # no capabilities).
        systemd.services.esphome-probe = {
          inherit (config.systemd.services.esphome) path;
          environment = removeAttrs config.systemd.services.esphome.environment [ "PATH" ];
          serviceConfig = config.systemd.services.esphome.serviceConfig // {
            Type = "oneshot";
            ExecStart = [
              "${lib.getExe pkgs.esphome} version"
              (lib.getExe esphomeFHSProbe)
            ];
            Restart = "no";
          };
        };
      };

    esphomeUnix =
      { ... }:
      {
        services.esphome = {
          enable = true;
          enableUnixSocket = true;
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
  };

  testScript = ''
    esphomeTcp.wait_for_unit("esphome.service")
    esphomeTcp.wait_for_open_port(${toString testPort})
    esphomeTcp.succeed("curl --fail http://localhost:${toString testPort}/")

    with subtest("the esphome FHS env runs a generic Linux ELF with the esphome unit's hardening"):
        esphomeTcp.succeed("systemctl start esphome-probe.service")
        output = esphomeTcp.succeed("journalctl -o cat -u esphome-probe.service")
        assert "Version: ${pkgs.esphome.version}" in output, output
        assert "/usr/bin/sh" in output, output
        assert "generic-linux-ok zlib" in output, output

    with subtest("the generic Linux ELF does not run outside the FHS env"):
        output = esphomeTcp.fail("${genericElf}/bin/generic-hello 2>&1")
        assert "NixOS cannot run dynamically linked executables" in output, output

    esphomeUnix.wait_for_unit("esphome.service")
    esphomeUnix.wait_for_file("${unixSocket}")
    esphomeUnix.succeed("curl --fail --unix-socket ${unixSocket} http://localhost/")

    esphomeRemoteBuild.wait_for_unit("esphome.service")
    esphomeRemoteBuild.wait_for_open_port(${toString remoteBuildPort})
  '';
}
