On some kernel versions user ashgillman has experiences suspend issues
(see https://bugzilla.redhat.com/show_bug.cgi?id=1597481).

Try:

```nix
boot.kernelPackages = pkgs.linuxPackages_4_14;
```
