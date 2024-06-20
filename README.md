# XnodeOS
XnodeOS is a modularised opinionated-yet-configurable operating system for Xnodes based on NixOS.

## building
1. `make clean`
2. `make iso` or `make netboot`

## requirements
You must have the nix package installed for this build to work.

## testing netboot
```
make clean netboot
cd result
python3 -m http.server&
qemu-system-x86_64 -enable-kvm -m 4G -cpu core2duo -serial mon:stdio -net user,bootfile="http://127.0.0.1:8000/ipxe_test_entrypoint" -net nic -msg timestamp=on
```

### FEATURE: SSH-Keys
In the local environment where you are running make iso you need to pass the key in by one of the following methods:
Export an environment Variable
`export sshPublicKey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC ..."`
CLI Parameter (in Makefile under make iso)
`nix-build --arg sshPublicKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC ..."`

Note/to-do: Testing inadequate so far due to a VM networking issue.
