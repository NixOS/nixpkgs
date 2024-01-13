{ lib, pkgs }:

with pkgs;

rec {

  sourceTarball = args: import ./source-tarball.nix (
    { inherit lib stdenv autoconf automake libtool;
    } // args);

  makeSourceTarball = sourceTarball; # compatibility

  binaryTarball = args: import ./binary-tarball.nix (
    { inherit lib stdenv;
    } // args);

  mvnBuild = args: import ./maven-build.nix (
    { inherit lib stdenv;
    } // args);

  nixBuild = args: import ./nix-build.nix (
    { inherit lib stdenv;
    } // args);

  coverageAnalysis = args: nixBuild (
    { inherit lcov enableGCOVInstrumentation makeGCOVReport;
      doCoverageAnalysis = true;
    } // args);

  clangAnalysis = args: nixBuild (
    { inherit clang-analyzer;
      doClangAnalysis = true;
    } // args);

  coverityAnalysis = args: nixBuild (
    { inherit cov-build xz;
      doCoverityAnalysis = true;
    } // args);

  rpmBuild = args: import ./rpm-build.nix (
    { inherit lib vmTools;
    } // args);

  debBuild = args: import ./debian-build.nix (
    { inherit lib stdenv vmTools checkinstall;
    } // args);

  aggregate =
    { name, constituents, meta ? { } }:
    pkgs.runCommand name
      { inherit constituents meta;
        preferLocalBuild = true;
        _hydraAggregate = true;
      }
      ''
        mkdir -p $out/nix-support
        touch $out/nix-support/hydra-build-products
        echo $constituents > $out/nix-support/hydra-aggregate-constituents

        # Propagate build failures.
        for i in $constituents; do
          if [ -e $i/nix-support/failed ]; then
            touch $out/nix-support/failed
          fi
        done
      '';

  /* Create a channel job which success depends on the success of all of
     its contituents. Channel jobs are a special type of jobs that are
     listed in the channel tab of Hydra and that can be suscribed.
     A tarball of the src attribute is distributed via the channel.

     - constituents: a list of derivations on which the channel success depends.
     - name: the channel name that will be used in the hydra interface.
     - src: should point to the root folder of the nix-expressions used by the
            channel, typically a folder containing a `default.nix`.

       channel {
         constituents = [ foo bar baz ];
         name = "my-channel";
         src = ./.;
       };

  */
  channel =
    { name, src, constituents ? [], meta ? {}, isNixOS ? true, ... }@args:
    stdenv.mkDerivation ({
      preferLocalBuild = true;
      _hydraAggregate = true;

      dontConfigure = true;
      dontBuild = true;

      patchPhase = lib.optionalString isNixOS ''
        touch .update-on-nixos-rebuild
      '';

      installPhase = ''
        mkdir -p $out/{tarballs,nix-support}

        tar cJf "$out/tarballs/nixexprs.tar.xz" \
          --owner=0 --group=0 --mtime="1970-01-01 00:00:00 UTC" \
          --transform='s!^\.!${name}!' .

        echo "channel - $out/tarballs/nixexprs.tar.xz" > "$out/nix-support/hydra-build-products"
        echo $constituents > "$out/nix-support/hydra-aggregate-constituents"

        # Propagate build failures.
        for i in $constituents; do
          if [ -e "$i/nix-support/failed" ]; then
            touch "$out/nix-support/failed"
          fi
        done
      '';

      meta = meta // {
        isHydraChannel = true;
      };
    } // removeAttrs args [ "meta" ]);

}
