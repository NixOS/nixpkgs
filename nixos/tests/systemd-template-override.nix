import ./make-test-python.nix {
  name = "systemd-template-override";

  machine = { pkgs, lib, ... }: let
    touchTmp = pkgs.writeTextFile {
      name = "touch-tmp@.service";
      text = ''
        [Service]
        Type=oneshot
        ExecStart=${pkgs.coreutils}/bin/touch /tmp/%I
      '';
      destination = "/etc/systemd/system/touch-tmp@.service";
    };
  in {
    systemd.packages = [ touchTmp ];

    systemd.services."touch-tmp@forbidden" = {
      serviceConfig.ExecStart = [ "" ''
        ${pkgs.coreutils}/bin/true
      ''];
    };

    systemd.services."touch-tmp@intercept" = {
      serviceConfig.ExecStart = [ "" ''
        ${pkgs.coreutils}/bin/touch /tmp/renamed
      ''];
    };
  };

  testScript = ''
    machine.wait_for_unit("default.target")

    machine.succeed("systemctl start touch-tmp@normal")
    machine.succeed("systemctl start touch-tmp@forbbidden")
    machine.succeed("systemctl start touch-tmp@intercept")

    machine.succeed("[ -e /tmp/normal ]")
    machine.succeed("[ ! -e /tmp/forbidden ]")
    machine.succeed("[ -e /tmp/renamed ]")
  '';
}
