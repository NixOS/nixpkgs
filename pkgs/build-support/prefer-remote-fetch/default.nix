# An overlay that download sources on remote builder.
# This is useful when the evaluating machine has a slow
# upload while the builder can fetch faster directly from the source.
# Usage: Put the following snippet in your usual overlay definition:
#
#   self: super:
#     (super.prefer-remote-fetch self super)
# Full configuration example for your own account:
#
# $ mkdir ~/.config/nixpkgs/overlays/
# $ echo 'self: super: super.prefer-remote-fetch self super' > ~/.config/nixpkgs/overlays/prefer-remote-fetch.nix
#
self: super: {
  fetchurl = args: super.fetchurl ({ preferLocalBuild = false; } // args);
  fetchgit = args: super.fetchgit ({ preferLocalBuild = false; } // args);
  fetchhg = args: super.fetchhg ({ preferLocalBuild = false; } // args);
  fetchsvn = args: super.fetchsvn ({ preferLocalBuild = false; } // args);
  fetchipfs = args: super.fetchipfs ({ preferLocalBuild = false; } // args);
}
