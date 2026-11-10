# NCR {#module-programs-ncr}

Enable NCR and set its default flake:

```nix
{
  programs.ncr = {
    enable = true;
    flake = "/home/user/nixconf";
  };
}
```

Run {command}`ncr` to report evaluation time and closure size for configurations
matching the current system. Pass a flake path or URL to override the default.
