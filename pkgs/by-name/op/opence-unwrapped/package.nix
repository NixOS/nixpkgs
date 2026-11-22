{ pkgsi686Linux }:

# The engine stores pointers in 32-bit game structures, including on x86_64.
pkgsi686Linux.callPackage ./unwrapped.nix { }
