{ nixpkgs ? ../../nixpkgs }:

{
  makeIso =
    { module, type, description ? type, maintainers ? ["eelco"] }:
    { nixosSrc ? {outPath = ./.; rev = 1234;}
    , officialRelease ? false
    , system ? "i686-linux"
    }:

    with import nixpkgs {inherit system;};

    let

      version = builtins.readFile ../VERSION + (if officialRelease then "" else "pre${toString nixosSrc.rev}");

      versionModule =
        { system.nixosVersion = version;
          isoImage.isoBaseName = "nixos-${type}";
        };

      config = (import ./eval-config.nix {
        inherit system nixpkgs;
        modules = [ module versionModule ];
      }).config;

      iso = config.system.build.isoImage;

    in
      # Declare the ISO as a build product so that it shows up in Hydra.
      runCommand "nixos-iso-${version}"
        { meta = {
            description = "NixOS installation CD (${description}) - ISO image for ${system}";
            maintainers = map (x: lib.getAttr x lib.maintainers) maintainers;
          };
          inherit iso;
          passthru = { inherit config; };
        }
        ''
          ensureDir $out/nix-support
          echo "file iso" $iso/iso/*.iso* >> $out/nix-support/hydra-build-products
        ''; # */


  makeSystemTarball =
    { module, maintainers ? ["viric"]}:
    { nixosSrc ? {outPath = ./.; rev = 1234;}
    , officialRelease ? false
    , system ? "i686-linux"
    }:

    with import nixpkgs {inherit system;};
    let
      version = builtins.readFile ../VERSION + (if officialRelease then "" else "pre${toString nixosSrc.rev}");

      versionModule = { system.nixosVersion = version; };

      config = (import ./eval-config.nix {
        inherit system nixpkgs;
        modules = [ module versionModule ];
      }).config;

      tarball = config.system.build.tarball;
    in
      tarball //
        { meta = {
            description = "NixOS system tarball for ${system} - ${stdenv.platform.name}";
            maintainers = map (x: lib.getAttr x lib.maintainers) maintainers;
          };
          inherit config;
        };
}
