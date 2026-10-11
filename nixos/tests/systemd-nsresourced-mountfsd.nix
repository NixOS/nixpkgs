{
  lib,
  pkgs,
  ...
}:

{
  name = "systemd-nsresourced-mountfsd";

  meta.maintainers = with lib.maintainers; [ raitobezarius ];

  nodes.machine = { config, ... }: {
    # Currently, kernel BTF enabled systemd is not the default yet.
    systemd.package = config.boot.kernelPackages.systemd;
    systemd.additionalUpstreamSystemUnits = [
      "systemd-nsresourced.socket"
      "systemd-nsresourced.service"
      "systemd-mountfsd.socket"
      "systemd-mountfsd.service"
    ];
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    with subtest("BPF LSM is active"):
        lsm = machine.succeed("cat /sys/kernel/security/lsm")
        assert "bpf" in lsm, f"BPF LSM is not active: {lsm}"

    with subtest("nsresourced and mountfsd sockets are available"):
        machine.systemctl("start systemd-nsresourced.socket systemd-mountfsd.socket")
        machine.wait_for_unit("systemd-nsresourced.socket")
        machine.wait_for_unit("systemd-mountfsd.socket")

    with subtest("nsresourced serves its varlink interface and delegates a user namespace"):
        machine.succeed("varlinkctl introspect /run/systemd/userdb/io.systemd.NamespaceResource")
        machine.succeed(
            "unshare --user varlinkctl --exec call "
            "--push-fd=/proc/self/ns/user "
            "/run/systemd/userdb/io.systemd.NamespaceResource "
            "io.systemd.NamespaceResource.AllocateUserRange "
            "'{\"name\":\"nixos-test\",\"size\":65536,\"userNamespaceFileDescriptor\":0}' "
            "-- cat /proc/self/uid_map"
        )

    with subtest("mountfsd serves its varlink interface"):
        machine.succeed("varlinkctl introspect /run/systemd/io.systemd.MountFileSystem")

    with subtest("mountfsd mounts a DDI on behalf of a client"):
        machine.succeed("mkdir -p /tmp/ddi-defs")
        machine.succeed("echo '[Partition]' > /tmp/ddi-defs/10-root.conf")
        machine.succeed("echo 'Type=root' >> /tmp/ddi-defs/10-root.conf")
        machine.succeed("echo 'Format=ext4' >> /tmp/ddi-defs/10-root.conf")
        machine.succeed(
            "PATH=${pkgs.e2fsprogs}/bin:$PATH "
            "systemd-repart --empty=create --size=64M "
            "--definitions=/tmp/ddi-defs --offline=yes /var/tmp/ddi.raw"
        )
        # SYSTEMD_USE_MOUNTFSD forces systemd-dissect to go through
        # systemd-mountfsd (and systemd-nsresourced) instead of mounting the
        # image locally.
        # NOTE: image-policy should be restricted but I failed to do so.
        machine.succeed(
            "SYSTEMD_USE_MOUNTFSD=1 systemd-dissect "
            "--image-policy='*' --mtree /var/tmp/ddi.raw"
        )
  '';
}
