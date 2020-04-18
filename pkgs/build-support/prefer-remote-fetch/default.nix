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
  fetchurl = args: super.fetchurl (args // { preferLocalBuild = false; });
  fetchgit = args: super.fetchgit (args // { preferLocalBuild = false; });
  fetchhg = args: super.fetchhg (args // { preferLocalBuild = false; });
  fetchsvn = args: super.fetchsvn (args // { preferLocalBuild = false; });
  fetchipfs = args: super.fetchipfs (args // { preferLocalBuild = false; });
}
