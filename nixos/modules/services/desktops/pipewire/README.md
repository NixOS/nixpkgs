# Updating

1. Update the version & hash in pkgs/development/libraries/pipewire/default.nix
2. run `nix build -f /path/to/nixpkgs/checkout pipewire pipewire.mediaSession`
3. copy all JSON files from result/nix-support/etc/pipewire and result-mediaSession/nix-support/etc/pipewire/media-session.d to this directory, like this: `cp result/nix-support/etc/pipewire/* result-mediaSession/nix-support/etc/pipewire/media-session.d/* .`
4. add new files to the module config and passthru tests
