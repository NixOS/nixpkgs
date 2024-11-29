import ./make-test-python.nix ({ pkgs, lib, ... }:

let
  seatd-test = pkgs.writeShellApplication {
    name = "seatd-client-pid";
    text = ''
      journalctl -u seatd --no-pager -b | while read -r line; do
          case "$line" in
          *"New client connected"*)
              line="''${line##*pid: }"
              pid="''${line%%,*}"
              ;;
          *"Opened client"*)
              echo "$pid"
              exit
          esac
      done;
    '';
  };
in
{
  name = "seatd";
  meta.maintainers = with lib.maintainers; [ sinanmohd ];

  nodes.machine = { ... }: {
    imports = [ ./common/user-account.nix ];
    services.getty.autologinUser = "alice";
    users.users.alice.extraGroups = [ "seat" "wheel" ];

    fonts.enableDefaultPackages = true;
    environment.systemPackages = with pkgs; [
      dwl
      foot
      seatd-test
    ];

    programs.bash.loginShellInit = ''
      [ "$(tty)" = "/dev/tty1" ] &&
          dwl -s 'foot touch /tmp/foot_started'
    '';

    hardware.graphics.enable = true;
    virtualisation.qemu.options = [ "-vga none -device virtio-gpu-pci" ];
    services.seatd.enable = true;
  };

  testScript = ''
    machine.wait_for_file("/tmp/foot_started")
    machine.succeed("test $(seatd-client-pid) = $(pgrep dwl)")
  '';
})
