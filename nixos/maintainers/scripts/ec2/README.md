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

I suggest looking at https://github.com/nix-community/nixos-generators for a user-friendly interface.

```bash
nixos-generate -c ./my-config.nix -f amazon

export AWS_REGION=us-west-2
export AWS_PROFILE=my-profile
nix run github:NixOS/amis#upload-ami -- --image-info ./result/nix-support/image-info.json
```

## Roadmap

* @arianvp is planning to drop zfs support unless someone else picks it up
* @arianvp is planning to rewrite the image builder to use the repart-based image builder.
* @arianvp is planning to perhaps rewrite `upload-ami` to use coldnsap
* @arianvp is planning to move `upload-ami` tooling into nixpkgs once it has stabilized. And only keep the Github Action in separate repo
