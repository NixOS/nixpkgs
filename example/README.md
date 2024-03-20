
# Module Based Service Abstraction Layer usage example

This directory demonstrates
 - `configuration.nix`: How to use an abstract service module on NixOS
 - `generic-python-http-server.nix`: A simple abstract service
 - `nixos-test.nix`: Make it runnable
    - `nix build example/nixos-test.nix`

Mess around with the repl

    nix repl -f example/nixos-test.nix
    nix-repl> nodes.machine.services.abstract.<TAB>
    args
    daemon
    ...

Enjoy!
