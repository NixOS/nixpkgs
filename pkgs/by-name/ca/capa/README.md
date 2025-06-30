## Updating version and corresponding hashes

To update the version of Capa in this package, bump the version number in `package.nix` and then run `./update-hashes.sh`

## Testing

Run the following in the root of `nixpkgs` to test the package:

```
nix-build --attr pkgs.capa.passthru.tests
```
