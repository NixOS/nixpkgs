{ lib, ... }:

{
  name = "kmonad";

  meta = {
    maintainers = with lib.maintainers; [ linj ];
  };

  nodes = {
    machine = {
      services.kmonad = {
        enable = true;
        extraArgs = [
          "--log-level=debug"
        ];
        keyboards = {
          defaultKbd = {
            device = "/dev/input/by-id/vm-default-kbd";
            defcfg = {
              enable = true;
              fallthrough = true;
            };
            config = ''
              (defsrc :name default-src
                1)
              (deflayer default-layer :source default-src
                @T2)
              (defalias
                T2 2)
            '';
          };
        };
      };

      # make a determinate symlink to the default vm keyboard for kmonad to use
      services.udev.extraRules = ''
        ACTION=="add", KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="QEMU Virtio Keyboard", ATTRS{id/product}=="0001", ATTRS{id/vendor}=="0627", SYMLINK+="input/by-id/vm-default-kbd"
      '';
    };
  };

  testScript = ''
    service_name = "kmonad-defaultKbd"
    machine.wait_for_unit(f"{service_name}.service")

    with subtest("kmonad is running"):
         machine.succeed(f"systemctl status {service_name}")
    with subtest("kmonad symlink is created"):
         machine.wait_for_file(f"/dev/input/by-id/{service_name}", timeout=5)
  '';
}
