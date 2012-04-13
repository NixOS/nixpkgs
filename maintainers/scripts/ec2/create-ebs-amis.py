#! /usr/bin/env python

import sys
from charon import deployment
from boto.ec2.blockdevicemapping import BlockDeviceMapping, BlockDeviceType
import charon.util
import time
import argparse

parser = argparse.ArgumentParser(description='Create an EBS-backed NixOS AMI')
parser.add_argument('--region', dest='region', required=True, help='EC2 region')
parser.add_argument('--keep', dest='keep', action='store_true', help='keep Charon machine after use')
args = parser.parse_args()

# Start a NixOS machine in the given region.
f = open("ebs-creator-zone.nix", "w")
f.write('{{ machine.deployment.ec2.region = "{0}"; }}'.format(args.region))
f.close()

depl = deployment.Deployment("./ebs-creator.json", create=True, nix_exprs=["./ebs-creator.nix", "./ebs-creator-zone.nix"])
if not args.keep: depl.destroy_vms()
depl.deploy()

m = depl.machines['machine']

# Do the installation.
m.run_command("if mountpoint -q /mnt; then umount /mnt; fi")
m.run_command("mkfs.ext4 -L nixos /dev/xvdg")
m.run_command("mkdir -p /mnt")
m.run_command("mount /dev/xvdg /mnt")
m.run_command("touch /mnt/.ebs")
m.run_command("mkdir -p /mnt/etc/nixos")
m.run_command("nixos-checkout") # FIXME
m.run_command("cp -f /etc/nixos/nixos/modules/virtualisation/amazon-config.nix /mnt/etc/nixos/configuration.nix")
m.run_command("echo -n pre$(svnversion -c /etc/nixos/nixos | sed 's/.*://')-$(svnversion -c /etc/nixos/nixpkgs | sed 's/.*://') > /etc/nixos/nixos/.version-suffix")
version = m.run_command("nixos-option system.nixosVersion", capture_stdout=True).replace('"', '').rstrip()
print >> sys.stderr, "NixOS version is {0}".format(version)
m.run_command("nixos-install")
m.run_command("rm -rf /mnt/etc/nixos/nixos/.svn /mnt/etc/nixos/nixpkgs/.svn")
m.run_command("umount /mnt")

ami_name = "nixos-{0}-x86_64-ebs".format(version)
description = "NixOS {0} (x86_64; EBS root)".format(version)

# Create a snapshot.
m.connect()
volume = m._conn.get_all_volumes([], filters={'attachment.instance-id': m._instance_id, 'attachment.device': "/dev/sdg"})[0]
snapshot = volume.create_snapshot(description=description)
print >> sys.stderr, "created snapshot {0}".format(snapshot.id)

# Wait for the snapshot to finish.
def check():
    status = snapshot.update()
    print >> sys.stderr, "snapshot status is {0}".format(status)
    return status == '100%'
charon.util.check_wait(check, max_tries=120)

m._conn.create_tags([snapshot.id], {'Name': ami_name})

if not args.keep: depl.destroy_vms()

# Register the image.
aki = m._conn.get_all_images(filters={'manifest-location': '*pv-grub-hd0_1.03-x86_64*'})[0]
print >> sys.stderr, "using kernel image {0} - {1}".format(aki.id, aki.location)

block_map = BlockDeviceMapping()
block_map['/dev/sda'] = BlockDeviceType(snapshot_id=snapshot.id, delete_on_termination=True)
block_map['/dev/sdb'] = BlockDeviceType(ephemeral_name="ephemeral0")
block_map['/dev/sdc'] = BlockDeviceType(ephemeral_name="ephemeral1")
block_map['/dev/sdd'] = BlockDeviceType(ephemeral_name="ephemeral2")
block_map['/dev/sde'] = BlockDeviceType(ephemeral_name="ephemeral3")

ami_id = m._conn.register_image(
    name=ami_name,
    description=description,
    architecture="x86_64",
    root_device_name="/dev/sda",
    kernel_id=aki.id,
    block_device_map=block_map)

print >> sys.stderr, "registered AMI {0}".format(ami_id)

time.sleep(5)
print >> sys.stderr, "making image public..."
image = m._conn.get_all_images(image_ids=[ami_id])[0]
image.set_launch_permissions(user_ids=[], group_names=["all"])

m._conn.create_tags([ami_id], {'Name': ami_name})

# Do a test deployment to make sure that the AMI works.
f = open("ebs-test.nix", "w")
f.write(
    '''
    {{ network.description = "NixOS EBS test";
       machine.deployment.targetEnv = "ec2";
       machine.deployment.ec2.region = "{0}";
       machine.deployment.ec2.instanceType = "m1.small";
       machine.deployment.ec2.keyPair = "eelco";
       machine.deployment.ec2.securityGroups = [ "eelco-test" ];
       machine.deployment.ec2.ami = "{1}";
    }}
    '''.format(args.region, ami_id))
f.close()

test_depl = deployment.Deployment("./ebs-test.json", create=True, nix_exprs=["./ebs-test.nix"])
test_depl.deploy(create_only=True)
test_depl.machines['machine'].run_command("nixos-version")
if not args.keep: test_depl.destroy_vms()

# Log the AMI ID.
f = open("{0}.ebs.ami-id".format(args.region), "w")
f.write("{0}".format(ami_id))
f.close()
