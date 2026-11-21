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

## Roadmap

* @arianvp is planning to perhaps rewrite `upload-ami` to use coldnsap
* @arianvp is planning to move `upload-ami` tooling into nixpkgs once it has stabilized. And only keep the Github Action in separate repo
