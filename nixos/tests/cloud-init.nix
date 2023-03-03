{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

let
  inherit (import ./ssh-keys.nix pkgs)
    snakeOilPrivateKey snakeOilPublicKey;

  metadataDrive = pkgs.stdenv.mkDerivation {
    name = "metadata";
    buildCommand = ''
      mkdir -p $out/iso

      cat << EOF > $out/iso/user-data
      #cloud-config
      write_files:
      -   content: |
                cloudinit
          path: /tmp/cloudinit-write-file

      users:
        - default
        - name: nixos
          ssh_authorized_keys:
            - "${snakeOilPublicKey}"
      EOF

      cat << EOF > $out/iso/meta-data
      instance-id: iid-local01
      local-hostname: "test"
      public-keys:
        - "${snakeOilPublicKey}"
      EOF

      cat << EOF > $out/iso/network-config
      version: 1
      config:
          - type: physical
            name: eth0
            mac_address: '52:54:00:12:34:56'
            subnets:
            - type: static
              address: '12.34.56.78'
              netmask: '255.255.255.0'
              gateway: '12.34.56.9'
          - type: nameserver
            address:
            - '6.7.8.9'
            search:
            - 'example.com'
      EOF
      ${pkgs.cdrkit}/bin/genisoimage -volid cidata -joliet -rock -o $out/metadata.iso $out/iso
      '';
  };

in makeTest {
  name = "cloud-init";
  meta.maintainers = with pkgs.lib.maintainers; [ lewo illustris ];
  nodes.machine = { ... }:
  {
    virtualisation.qemu.options = [ "-cdrom" "${metadataDrive}/metadata.iso" ];
    services.cloud-init = {
      enable = true;
      network.enable = true;
    };
    services.openssh.enable = true;
    networking.hostName = "";
    networking.useDHCP = false;
  };
  testScript = ''
    # To wait until cloud-init terminates its run
    unnamed.wait_for_unit("cloud-final.service")

    unnamed.succeed("cat /tmp/cloudinit-write-file | grep -q 'cloudinit'")

    # install snakeoil ssh key and provision .ssh/config file
    unnamed.succeed("mkdir -p ~/.ssh")
    unnamed.succeed(
        "cat ${snakeOilPrivateKey} > ~/.ssh/id_snakeoil"
    )
    unnamed.succeed("chmod 600 ~/.ssh/id_snakeoil")

    unnamed.wait_for_unit("sshd.service")

    # we should be able to log in as the root user, as well as the created nixos user
    unnamed.succeed(
        "timeout 10 ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=~/.ssh/id_snakeoil root@localhost 'true'"
    )
    unnamed.succeed(
        "timeout 10 ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=~/.ssh/id_snakeoil nixos@localhost 'true'"
    )

    # test changing hostname via cloud-init worked
    assert (
        unnamed.succeed(
            "timeout 10 ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=~/.ssh/id_snakeoil nixos@localhost 'hostname'"
        ).strip()
        == "test"
    )

    # check IP and route configs
    assert "default via 12.34.56.9 dev eth0 proto static" in unnamed.succeed("ip route")
    assert "12.34.56.0/24 dev eth0 proto kernel scope link src 12.34.56.78" in unnamed.succeed("ip route")

    # check nameserver and search configs
    assert "6.7.8.9" in unnamed.succeed("resolvectl status")
    assert "example.com" in unnamed.succeed("resolvectl status")

  '';
}
