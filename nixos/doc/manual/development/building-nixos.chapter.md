# Building Your Own NixOS CD {#sec-building-cd}
Building a NixOS CD is as easy as configuring your own computer. The idea is to use another module which will replace your `configuration.nix` to configure the system that would be installed on the CD.

Default CD/DVD configurations are available inside `nixos/modules/installer/cd-dvd`

```ShellSession
$ git clone https://github.com/NixOS/nixpkgs.git
$ cd nixpkgs/nixos
$ nix-build -A config.system.build.isoImage -I nixos-config=modules/installer/cd-dvd/installation-cd-minimal.nix default.nix
```

Before burning your CD/DVD, you can check the content of the image by mounting anywhere like suggested by the following command:

```ShellSession
# mount -o loop -t iso9660 ./result/iso/cd.iso /mnt/iso</screen>
```

If you want to customize your NixOS CD in more detail, or generate other kinds of images, you might want to check out [nixos-generators](https://github.com/nix-community/nixos-generators). This can also be a good starting point when you want to use Nix to build a 'minimal' image that doesn't include a NixOS installation.
