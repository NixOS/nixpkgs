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
  binary-cache = args: super.binary-cache ({ preferLocalBuild = false; } // args);
  buildenv = args: super.buildenv ({ preferLocalBuild = false; } // args);
  fetchfossil = args: super.fetchfossil ({ preferLocalBuild = false; } // args);
  fetchdocker = args: super.fetchdocker ({ preferLocalBuild = false; } // args);
  fetchgit = args: super.fetchgit ({ preferLocalBuild = false; } // args);
  fetchgx = args: super.fetchgx ({ preferLocalBuild = false; } // args);
  fetchhg = args: super.fetchhg ({ preferLocalBuild = false; } // args);
  fetchipfs = args: super.fetchipfs ({ preferLocalBuild = false; } // args);
  fetchrepoproject = args: super.fetchrepoproject ({ preferLocalBuild = false; } // args);
  fetchs3 = args: super.fetchs3 ({ preferLocalBuild = false; } // args);
  fetchsvn = args: super.fetchsvn ({ preferLocalBuild = false; } // args);
  fetchurl =
    fpArgs:
    super.fetchurl (
      super.lib.extends (finalAttrs: args: { preferLocalBuild = args.preferLocalBuild or false; }) (
        super.lib.toFunction fpArgs
      )
    );
  mkNugetSource = args: super.mkNugetSource ({ preferLocalBuild = false; } // args);
}
