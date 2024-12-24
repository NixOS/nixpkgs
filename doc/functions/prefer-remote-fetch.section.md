# prefer-remote-fetch overlay {#sec-prefer-remote-fetch}

`prefer-remote-fetch` is an overlay that download sources on remote builder. This is useful when the evaluating machine has a slow upload while the builder can fetch faster directly from the source. To use it, put the following snippet as a new overlay:

```nix
self: super:
  (super.prefer-remote-fetch self super)
```

A full configuration example for that sets the overlay up for your own account, could look like this

```ShellSession
$ mkdir ~/.config/nixpkgs/overlays/
$ cat > ~/.config/nixpkgs/overlays/prefer-remote-fetch.nix <<EOF
  self: super: super.prefer-remote-fetch self super
EOF
```
