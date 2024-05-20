# XnodeOS
XnodeOS is a modularised configurable operating-system for servers built on NixOS, you can find all of our nix flakes and modules here.

## building
1. `make clean`
2. `make iso`

## requirements
You must have the nix package installed for this build to work.


### FEATURE: SSH-Keys
In the local environment where you are running make iso you need to pass the key in by one of the following methods:
Export an environment Variable
`export sshPublicKey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC ..."`
CLI Parameter (in Makefile under make iso)
`nix-build --arg sshPublicKey "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC ..."`

Note/to-do: Testing inadequate so far due to a VM networking issue.
