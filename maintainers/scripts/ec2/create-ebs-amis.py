#! /usr/bin/env python

import sys
from charon import deployment
from boto.ec2.blockdevicemapping import BlockDeviceMapping, BlockDeviceType
import charon.util

depl = deployment.Deployment("./ebs-creator.json", create=True, nix_exprs=["./ebs-creator.nix"])
depl.deploy()

m = depl.machines['machine']

# Do the installation.
m.run_command("if mountpoint -q /mnt; then umount /mnt; fi")
m.run_command("mkfs.ext4 -L nixos /dev/xvdg")
m.run_command("mkdir -p /mnt")
m.run_command("mount /dev/xvdg /mnt")
m.run_command("touch /mnt/.ebs")
m.run_command("mkdir -p /mnt/etc/nixos")
m.run_command("cp /etc/nixos/configuration.nix /mnt/etc/nixos/") # FIXME
m.run_command("nixos-checkout") # FIXME
m.run_command("nixos-install")
m.run_command("umount /mnt")

# Create a snapshot.
m.connect()
volume = m._conn.get_all_volumes([], filters={'attachment.instance-id': m._instance_id, 'attachment.device': "/dev/sdg"})[0]
snapshot = volume.create_snapshot(description="NixOS EBS root disk")
#snapshot = m._conn.get_all_snapshots(["snap-f1c9679a"])[0]
print >> sys.stderr, "created snapshot {0}".format(snapshot.id)

# Wait for the snapshot to finish.
def check():
    status = snapshot.update()
    print >> sys.stderr, "snapshot status is {0}".format(status)
    return status == '100%'
charon.util.check_wait(check, max_tries=120)

# Register the image.
aki = m._conn.get_all_images(filters={'manifest-location': '*pv-grub-hd0_1.03-x86_64*'})[0]
print >> sys.stderr, "using kernel image %s - %s" %(aki.id, aki.location)

block_map = BlockDeviceMapping()
block_map['/dev/sda'] = BlockDeviceType(snapshot_id=snapshot.id, delete_on_termination=True)
block_map['/dev/sdb'] = BlockDeviceType(ephemeral_name="ephemeral0")
block_map['/dev/sdc'] = BlockDeviceType(ephemeral_name="ephemeral1")
block_map['/dev/sdd'] = BlockDeviceType(ephemeral_name="ephemeral2")
block_map['/dev/sde1'] = BlockDeviceType(ephemeral_name="ephemeral3")

ami_id = m._conn.register_image(
    name="nixos-x86-64-ebs-test-9", description="NixOS (x86_64) EBS test", architecture="x86_64",
    root_device_name="/dev/sda", kernel_id=aki.id, block_device_map=block_map)

print >> sys.stderr, "registered AMI {0}".format(ami_id)
