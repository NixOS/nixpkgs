# /etc files {#etc}

Certain calls in glibc require access to runtime files found in `/etc` such as `/etc/protocols` or `/etc/services` -- [getprotobyname](https://linux.die.net/man/3/getprotobyname) is one such function.

On non-NixOS distributions these files are typically provided by packages (i.e., [netbase](https://packages.debian.org/sid/netbase)) if not already pre-installed in your distribution. This can cause non-reproducibility for code if they rely on these files being present.

If [iana-etc](https://hydra.nixos.org/job/nixos/trunk-combined/nixpkgs.iana-etc.x86_64-linux) is part of your `buildInputs`, then it will set the environment variables `NIX_ETC_PROTOCOLS` and `NIX_ETC_SERVICES` to the corresponding files in the package through a setup hook.


```bash
> nix-shell -p iana-etc

[nix-shell:~]$ env | grep NIX_ETC
NIX_ETC_SERVICES=/nix/store/aj866hr8fad8flnggwdhrldm0g799ccz-iana-etc-20210225/etc/services
NIX_ETC_PROTOCOLS=/nix/store/aj866hr8fad8flnggwdhrldm0g799ccz-iana-etc-20210225/etc/protocols
```

Nixpkg's version of [glibc](https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/glibc/default.nix) has been patched to check for the existence of these environment variables. If the environment variables are *not* set, then it will attempt to find the files at the default location within `/etc`.
