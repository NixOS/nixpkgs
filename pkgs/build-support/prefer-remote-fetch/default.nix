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
  binary-cache = super.binary-cache.override { preferLocalBuild = false; };
  buildenv = super.buildenv.override { preferLocalBuild = false; };
  fetchfossil = super.fetchfossil.override { preferLocalBuild = false; };
  fetchdocker = super.fetchdocker.override { preferLocalBuild = false; };
  fetchgit = super.fetchgit.override { preferLocalBuild = false; };
  fetchgx = super.fetchgx.override { preferLocalBuild = false; };
  fetchhg = super.fetchhg.override { preferLocalBuild = false; };
  fetchipfs = super.fetchipfs.override { preferLocalBuild = false; };
  fetchrepoproject = super.fetchrepoproject.override { preferLocalBuild = false; };
  fetchs3 = super.fetchs3.override { preferLocalBuild = false; };
  fetchsvn = super.fetchsvn.override { preferLocalBuild = false; };
  fetchurl = super.fetchurl.override { preferLocalBuild = false; };
  mkNugetSource = super.mkNugetSource.override { preferLocalBuild = false; };
}
