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
self: super:
let
  preferLocal =
    orig:
    self.lib.extendMkDerivation {
      constructDrv = orig;
      extendDrvArgs =
        finalAttrs:
        {
          preferLocalBuild ? false,
          ...
        }:
        {
          inherit preferLocalBuild;
        };
    };

in
{
  binary-cache = preferLocal super.binary-cache;
  buildenv = preferLocal super.buildenv;
  fetchfossil = preferLocal super.fetchfossil;
  fetchdocker = preferLocal super.fetchdocker;
  fetchgit = (preferLocal super.fetchgit) // {
    inherit (super.fetchgit) getRevWithTag;
  };
  fetchgx = preferLocal super.fetchgx;
  fetchhg = preferLocal super.fetchhg;
  fetchipfs = preferLocal super.fetchipfs;
  fetchrepoproject = preferLocal super.fetchrepoproject;
  fetchs3 = preferLocal super.fetchs3;
  fetchsvn = preferLocal super.fetchsvn;
  fetchurl = preferLocal super.fetchurl;
  mkNugetSource = preferLocal super.mkNugetSource;
}
