#! /usr/bin/env python

import os
import sys
import time
import argparse
import nixops.util
from nixops import deployment
from boto.ec2.blockdevicemapping import BlockDeviceMapping, BlockDeviceType
import boto.ec2
from nixops.statefile import StateFile, get_default_state_file

parser = argparse.ArgumentParser(description='Create an EBS-backed NixOS AMI')
parser.add_argument('--region', dest='region', required=True, help='EC2 region to create the image in')
parser.add_argument('--channel', dest='channel', default="14.12", help='Channel to use')
parser.add_argument('--keep', dest='keep', action='store_true', help='Keep NixOps machine after use')
parser.add_argument('--hvm', dest='hvm', action='store_true', help='Create HVM image')
parser.add_argument('--key', dest='key_name', action='store_true', help='Keypair used for HVM instance creation', default="rob")
args = parser.parse_args()

instance_type = "m3.medium" if args.hvm else "m1.small"

if args.hvm:
    virtualization_type = "hvm"
    root_block = "/dev/sda1"
    image_type = 'hvm'
else:
    virtualization_type = "paravirtual"
    root_block = "/dev/sda"
    image_type = 'ebs'

ebs_size = 20

# Start a NixOS machine in the given region.
f = open("ebs-creator-config.nix", "w")
f.write('''{{
  resources.ec2KeyPairs.keypair.accessKeyId = "lb-nixos";
  resources.ec2KeyPairs.keypair.region = "{0}";

  machine =
    {{ pkgs, ... }}:
    {{
      deployment.ec2.accessKeyId = "lb-nixos";
      deployment.ec2.region = "{0}";
      deployment.ec2.blockDeviceMapping."/dev/xvdg".size = pkgs.lib.mkOverride 10 {1};
    }};
}}
'''.format(args.region, ebs_size))
f.close()

db = StateFile(get_default_state_file())
try:
    depl = db.open_deployment("ebs-creator")
except Exception:
    depl = db.create_deployment()
    depl.name = "ebs-creator"
depl.logger.set_autoresponse("y")
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

m.run_command("nix-channel --add https://nixos.org/channels/nixos-{} nixos".format(args.channel))
m.run_command("nix-channel --update")

version = m.run_command("nix-instantiate --eval-only -A lib.nixpkgsVersion '<nixpkgs>'", capture_stdout=True).split(' ')[0].replace('"','').strip()
print >> sys.stderr, "NixOS version is {0}".format(version)
if args.hvm:
    m.upload_file("./amazon-base-config.nix", "/mnt/etc/nixos/amazon-base-config.nix")
    m.upload_file("./amazon-hvm-config.nix", "/mnt/etc/nixos/configuration.nix")
    m.upload_file("./amazon-hvm-install-config.nix", "/mnt/etc/nixos/amazon-hvm-install-config.nix")
    m.run_command("NIXOS_CONFIG=/etc/nixos/amazon-hvm-install-config.nix nixos-install")
else:
    m.upload_file("./amazon-base-config.nix", "/mnt/etc/nixos/configuration.nix")
    m.run_command("nixos-install")

m.run_command("umount /mnt")

if args.hvm:
    ami_name = "nixos-{0}-x86_64-hvm".format(version)
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

# Create a snapshot.
snapshot = volume.create_snapshot(description=description)
print >> sys.stderr, "created snapshot {0}".format(snapshot.id)

nixops.util.check_wait(check, max_tries=120)

m._conn.create_tags([snapshot.id], {'Name': ami_name})

if not args.keep: depl.destroy_resources()

# Register the image.
aki = m._conn.get_all_images(filters={'manifest-location': 'ec2*pv-grub-hd0_1.03-x86_64*'})[0]
print >> sys.stderr, "using kernel image {0} - {1}".format(aki.id, aki.location)

block_map = BlockDeviceMapping()
block_map[root_block] = BlockDeviceType(snapshot_id=snapshot.id, delete_on_termination=True, size=ebs_size, volume_type="gp2")
block_map['/dev/sdb'] = BlockDeviceType(ephemeral_name="ephemeral0")
block_map['/dev/sdc'] = BlockDeviceType(ephemeral_name="ephemeral1")
block_map['/dev/sdd'] = BlockDeviceType(ephemeral_name="ephemeral2")
block_map['/dev/sde'] = BlockDeviceType(ephemeral_name="ephemeral3")

common_args = dict(
        name=ami_name,
        description=description,
        architecture="x86_64",
        root_device_name=root_block,
        block_device_map=block_map,
        virtualization_type=virtualization_type,
        delete_root_volume_on_termination=True
        )
if not args.hvm:
    common_args['kernel_id']=aki.id

ami_id = m._conn.register_image(**common_args)

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

      resources.ec2KeyPairs.keypair.accessKeyId = "lb-nixos";
      resources.ec2KeyPairs.keypair.region = "{0}";

      machine = {{ config, pkgs, resources, ... }}: {{
        deployment.targetEnv = "ec2";
        deployment.ec2.accessKeyId = "lb-nixos";
        deployment.ec2.region = "{0}";
        deployment.ec2.instanceType = "{2}";
        deployment.ec2.keyPair = resources.ec2KeyPairs.keypair.name;
        deployment.ec2.securityGroups = [ "public-ssh" ];
        deployment.ec2.ami = "{1}";
      }};
    }}
    '''.format(args.region, ami_id, instance_type))
f.close()

test_depl = db.create_deployment()
test_depl.auto_response = "y"
test_depl.name = "ebs-creator-test"
test_depl.nix_exprs = [os.path.abspath("./ebs-test.nix")]
test_depl.deploy(create_only=True)
test_depl.machines['machine'].run_command("nixos-version")

# Log the AMI ID.
f = open("ec2-amis.nix".format(args.region, image_type), "w")
f.write("{\n")

for dest in [ 'us-east-1', 'us-west-1', 'us-west-2', 'eu-west-1', 'eu-central-1', 'ap-southeast-1', 'ap-southeast-2', 'ap-northeast-1', 'sa-east-1']:
    copy_image = None
    if args.region != dest:
        try:
            print >> sys.stderr, "copying image from region {0} to {1}".format(args.region, dest)
            conn = boto.ec2.connect_to_region(dest)
            copy_image = conn.copy_image(args.region, ami_id, ami_name, description=None, client_token=None)
        except :
            print >> sys.stderr, "FAILED!"

        # Log the AMI ID.
        if copy_image != None:
            f.write('  "{0}"."{1}".{2} = "{3}";\n'.format(args.channel,dest,"hvm" if args.hvm else "ebs",copy_image.image_id))
    else:
        f.write('  "{0}"."{1}".{2} = "{3}";\n'.format(args.channel,args.region,"hvm" if args.hvm else "ebs",ami_id))


f.write("}\n")
f.close()

if not args.keep:
    test_depl.logger.set_autoresponse("y")
    test_depl.destroy_resources()
    test_depl.delete()

