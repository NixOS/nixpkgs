#! /usr/bin/env python

import os
import sys
import time
import argparse
import charon.util
from charon import deployment
from boto.ec2.blockdevicemapping import BlockDeviceMapping, BlockDeviceType

parser = argparse.ArgumentParser(description='Create an EBS-backed NixOS AMI')
parser.add_argument('--region', dest='region', required=True, help='EC2 region')
parser.add_argument('--keep', dest='keep', action='store_true', help='Keep Charon machine after use')
parser.add_argument('--hvm', dest='hvm', action='store_true', help='Create HVM image')
args = parser.parse_args()

instance_type = "cc1.4xlarge" if args.hvm else "m1.small"
ebs_size = 8 if args.hvm else 20


# Start a NixOS machine in the given region.
f = open("ebs-creator-config.nix", "w")
f.write('''{{
  resources.ec2KeyPairs.keypair.accessKeyId = "logicblox-dev";
  resources.ec2KeyPairs.keypair.region = "{0}";

  machine =
    {{ pkgs, ... }}:
    {{
      deployment.ec2.accessKeyId = "logicblox-dev";
      deployment.ec2.region = "{0}";
      deployment.ec2.blockDeviceMapping."/dev/xvdg".size = pkgs.lib.mkOverride 10 {1};
    }};
}}
'''.format(args.region, ebs_size))
f.close()

db = deployment.open_database(deployment.get_default_state_file())
try:
    depl = deployment.open_deployment(db, "ebs-creator")
except Exception:
    depl = deployment.create_deployment(db)
    depl.name = "ebs-creator"
depl.auto_response = "y"
depl.nix_exprs = [os.path.abspath("./ebs-creator.nix"), os.path.abspath("./ebs-creator-config.nix")]
if not args.keep: depl.destroy_resources()
depl.deploy(allow_reboot=True)

m = depl.machines['machine']


# Do the installation.
device="/dev/xvdg"
if args.hvm:
    m.run_command('parted -s /dev/xvdg -- mklabel msdos')
    m.run_command('parted -s /dev/xvdg -- mkpart primary ext2 1M -1s')
    device="/dev/xvdg1"

m.run_command("if mountpoint -q /mnt; then umount /mnt; fi")
m.run_command("mkfs.ext4 -L nixos {0}".format(device))
m.run_command("mkdir -p /mnt")
m.run_command("mount {0} /mnt".format(device))
m.run_command("touch /mnt/.ebs")
m.run_command("mkdir -p /mnt/etc/nixos")
m.run_command("nix-channel --add http://nixos.org/channels/nixos-unstable")
m.run_command("nix-channel --update")
m.run_command("nixos-rebuild switch")
version = m.run_command("nixos-version", capture_stdout=True).replace('"', '').rstrip()
print >> sys.stderr, "NixOS version is {0}".format(version)
m.run_command("cp -f $(nix-instantiate --find-file nixos/modules/virtualisation/amazon-config.nix) /mnt/etc/nixos/configuration.nix")
m.run_command("nixos-install")
if args.hvm:
    m.run_command('cp /mnt/nix/store/*-grub-0.97*/lib/grub/i386-pc/* /mnt/boot/grub')
    m.run_command('sed -i "s|hd0|hd0,0|" /mnt/boot/grub/menu.lst')
    m.run_command('echo "(hd1) /dev/xvdg" > device.map')
    m.run_command('echo -e "root (hd1,0)\nsetup (hd1)" | grub --device-map=device.map --batch')


m.run_command("umount /mnt")


if args.hvm:
    ami_name = "nixos-{0}-x86_64-ebs-hvm".format(version)
    description = "NixOS {0} (x86_64; EBS root; hvm)".format(version)
else:
    ami_name = "nixos-{0}-x86_64-ebs".format(version)
    description = "NixOS {0} (x86_64; EBS root)".format(version)


# Wait for the snapshot to finish.
def check():
    status = snapshot.update()
    print >> sys.stderr, "snapshot status is {0}".format(status)
    return status == '100%'

m.connect()
volume = m._conn.get_all_volumes([], filters={'attachment.instance-id': m.resource_id, 'attachment.device': "/dev/sdg"})[0]
if args.hvm:
    instance = m._conn.run_instances( image_id="ami-6a9e4503"
                                    , instance_type=instance_type
                                    , key_name=key_name
                                    , placement=m.zone
                                    , security_groups=["eelco-test"]).instances[0]
    charon.util.check_wait(lambda: instance.update() == 'running', max_tries=120)
    instance.stop()
    charon.util.check_wait(lambda: instance.update() == 'stopped', max_tries=120)
    old_root_volume = m._conn.get_all_volumes([], filters={'attachment.instance-id': instance.id, 'attachment.device': "/dev/sda1"})[0]
    old_root_volume.detach()
    volume.detach()
    charon.util.check_wait(lambda: volume.update() == 'available', max_tries=120)
    charon.util.check_wait(lambda: old_root_volume.update() == 'available', max_tries=120)
    volume.attach(instance.id, '/dev/sda1')
    charon.util.check_wait(lambda: volume.update() == 'in-use', max_tries=120)

    ami_id = m._conn.create_image(instance.id, ami_name, description)
    time.sleep(5)
    image = m._conn.get_all_images([ami_id])[0]
    charon.util.check_wait(lambda: image.update() == 'available', max_tries=120)
    instance.terminate()

else:
    # Create a snapshot.
    snapshot = volume.create_snapshot(description=description)
    print >> sys.stderr, "created snapshot {0}".format(snapshot.id)

    charon.util.check_wait(check, max_tries=120)

    m._conn.create_tags([snapshot.id], {'Name': ami_name})

    if not args.keep: depl.destroy_resources()

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

print >> sys.stderr, "sleeping a bit..."
time.sleep(30)

print >> sys.stderr, "setting image name..."
m._conn.create_tags([ami_id], {'Name': ami_name})

print >> sys.stderr, "making image public..."
image = m._conn.get_all_images(image_ids=[ami_id])[0]
image.set_launch_permissions(user_ids=[], group_names=["all"])


# Do a test deployment to make sure that the AMI works.
f = open("ebs-test.nix", "w")
f.write(
    '''
    {{
      network.description = "NixOS EBS test";

      resources.ec2KeyPairs.keypair.accessKeyId = "logicblox-dev";
      resources.ec2KeyPairs.keypair.region = "{0}";

      machine = {{ config, pkgs, resources, ... }}: {{
        deployment.targetEnv = "ec2";
        deployment.ec2.accessKeyId = "logicblox-dev";
        deployment.ec2.region = "{0}";
        deployment.ec2.instanceType = "{2}";
        deployment.ec2.keyPair = resources.ec2KeyPairs.keypair.name;
        deployment.ec2.securityGroups = [ "admin" ];
        deployment.ec2.ami = "{1}";
      }};
    }}
    '''.format(args.region, ami_id, instance_type))
f.close()

test_depl = deployment.create_deployment(db)
test_depl.auto_response = "y"
test_depl.name = "ebs-creator-test"
test_depl.nix_exprs = [os.path.abspath("./ebs-test.nix")]
test_depl.deploy(create_only=True)
test_depl.machines['machine'].run_command("nixos-version")
if not args.keep:
    test_depl.destroy_resources()
    test_depl.delete()

# Log the AMI ID.
f = open("{0}.ebs.ami-id".format(args.region), "w")
f.write("{0}".format(ami_id))
f.close()
