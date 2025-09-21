# Fake Certificate Authority for ACME testing

This will set up a test node running [pebble](https://github.com/letsencrypt/pebble)
to serve ACME certificate requests.

## "Snake oil" certs

The snake oil certs are hard-coded into the repo for reasons explained [here](https://github.com/NixOS/nixpkgs/pull/91121#discussion_r505410235).
The root of the issue is that Nix will hash the derivation based on the arguments
to mkDerivation, not the output. [Minica](https://github.com/jsha/minica) will
always generate a random certificate even if the arguments are unchanged. As a
result, it's possible to end up in a situation where the cached and local
generated certs mismatch and cause issues with testing.

To generate new certificates, run the following commands:

```bash
nix-build generate-certs.nix
cp result/* .
rm result
```
