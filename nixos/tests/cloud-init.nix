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
      ${pkgs.cdrkit}/bin/genisoimage -volid cidata -joliet -rock -o $out/metadata.iso $out/iso
      '';
  };
in makeTest {
  name = "cloud-init";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ lewo ];
  };
  machine = { ... }:
  {
    virtualisation.qemu.options = [ "-cdrom" "${metadataDrive}/metadata.iso" ];
    services.cloud-init.enable = true;
    services.openssh.enable = true;
    networking.hostName = "";
  };
  testScript = ''
    machine.wait_for_unit("cloud-init.service")
    machine.succeed("cat /tmp/cloudinit-write-file | grep -q 'cloudinit'")

    # install snakeoil ssh key and provision .ssh/config file
    machine.succeed("mkdir -p ~/.ssh")
    machine.succeed(
        "cat ${snakeOilPrivateKey} > ~/.ssh/id_snakeoil"
    )
    machine.succeed("chmod 600 ~/.ssh/id_snakeoil")

    machine.wait_for_unit("sshd.service")

    # we should be able to log in as the root user, as well as the created nixos user
    machine.succeed(
        "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=~/.ssh/id_snakeoil root@localhost 'true'"
    )
    machine.succeed(
        "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=~/.ssh/id_snakeoil nixos@localhost 'true'"
    )

    # test changing hostname via cloud-init worked
    assert (
        machine.succeed(
            "ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -o IdentityFile=~/.ssh/id_snakeoil nixos@localhost 'hostname'"
        ).strip()
        == "test"
    )
  '';
}
