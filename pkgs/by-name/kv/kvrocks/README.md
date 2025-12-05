# kvrocks

Apache Kvrocks is a distributed key-value NoSQL database that uses RocksDB as storage engine and is compatible with Redis protocol.

## Package Structure

- `package.nix` - Main package definition for building kvrocks
- `service.nix` - NixOS service module for running kvrocks as a system service
- `test-build.sh` - Script to test the package build

## Testing

To test the package build:

```bash
./test-build.sh
```

## NixOS Service Usage

To use kvrocks as a NixOS service, add to your configuration:

```nix
{
  services.kvrocks = {
    enable = true;
    settings = {
      port = 6666;
      bind = "127.0.0.1";
      "rocksdb.write_buffer_size" = 128;
    };
  };
}
```

## Submitting to nixpkgs

1. Place `package.nix` in `nixpkgs/pkgs/by-name/kv/kvrocks/`
2. Place `service.nix` in `nixpkgs/nixos/modules/services/databases/kvrocks.nix`
3. Add service import to `nixpkgs/nixos/modules/module-list.nix`
4. Test with `nix-build -A kvrocks` and NixOS VM tests
5. Submit PR to nixpkgs repository
