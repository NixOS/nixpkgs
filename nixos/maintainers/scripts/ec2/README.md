# Amazon images

AMIs are regularly uploaded from Hydra. This automation lives in
https://github.com/NixOS/amis


## How to upload an AMI for testing

If you want to upload an AMI from changes in a local nixpkgs checkout.

```bash
nix-build nixos/release.nix -A amazonImage

export AWS_REGION=us-west-2
export AWS_PROFILE=my-profile
nix run nixpkgs#upload-ami -- --image-info ./result/nix-support/image-info.json
```

## How to build your own NixOS config into an AMI

Use `nixos-rebuild build-image` as follows:

```bash
NIXOS_CONFIG="$(pwd)/my-config.nix" nixos-rebuild build-image --image-variant amazon

export AWS_REGION=us-west-2
export AWS_PROFILE=my-profile
nix run github:NixOS/amis#upload-ami -- --image-info ./result/nix-support/image-info.json
```

## image-info.json

`nix-support/image-info.json` describes the built image for uploaders. Besides
the image `file` and its `format` (`RAW`, `VHD` or `QCOW2`), it records:

* `store`: the `amazonImage.store` setting.
* `partitions`: the ESP (`esp`), the root file system (`root`) and, with an erofs
  store, the Nix store (`store`), each with its GPT `label`, partition `number`
  and `size` in bytes.

Partition numbers depend on the boot mode. Images that can also boot with legacy
BIOS have Limine's BIOS boot partition first, which moves every other partition
up by one. With an erofs store, for example, root is partition 3 on UEFI-only
images and partition 4 otherwise. Find partitions by `label`, or read their
`number` from this file, instead of hard-coding it.

`partitions.root.size` is the root partition's size in the image. Instances grow
the partition and its file system to fill the volume on first boot.

With `amazonImage.root = "first-boot"`, the image has no root partition and
`partitions.root` is absent. Don't expect it.

## Root partition growth

On first boot, and after the EBS volume grows, systemd-repart grows the root
partition in the initrd and systemd-growfs grows its file system. The image
defines that partition as `systemd.repart.partitions.root`. To use growpart
after boot instead, set:

```nix
{ boot.initrd.systemd.repart.enable = false; }
```

Without a `root` definition, growpart stays on even with initrd systemd-repart
enabled. `boot.growPartition` refuses to run alongside systemd-repart, so such a
configuration fails to evaluate until you add `root` back or set
`boot.growPartition = false`.

## Creating root on first boot

With `amazonImage.store = "erofs"` and `nix.enable = false`, the image needs no
root partition. `amazonImage.root = "first-boot"` leaves it out, and
systemd-repart creates it in the initrd on first boot, filling the volume, with
`amazonImage.rootFsType` (ext4 or xfs).

systemd-repart creates root on the disk that has the `nix-store` partition. See
[Volumes cloned from the image](#volumes-cloned-from-the-image) for what happens
when more than one disk has one.

## Volumes cloned from the image

Don't attach a volume cloned from this image's volume, or from a running
instance's root volume, to an instance that boots this image, at first boot or
later.

* With `amazonImage.root = "first-boot"`, the initrd checks on every boot
  whether more than one disk has a `nix-store` partition. If so, it stops in
  emergency mode before systemd-repart runs, and writes to neither disk. Detach
  the volume and reboot.
* With `amazonImage.store = "erofs"` or `"erofs-overlay"` and
  `amazonImage.root = "image"`, there is no such check. The initrd mounts the
  store by its partition label and root by its file system label, so it can
  mount either of them from the clone.

## Roadmap

* @arianvp is planning to perhaps rewrite `upload-ami` to use coldnsap
* @arianvp is planning to move `upload-ami` tooling into nixpkgs once it has stabilized. And only keep the Github Action in separate repo
