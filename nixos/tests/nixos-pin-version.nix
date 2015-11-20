{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
let
in

pkgs.stdenv.mkDerivation rec {
  name = "nixos-pin-version";
  src = ../..;
  buildInputs = with pkgs; [ nix gnugrep ];

    withoutPath = pkgs.writeText "configuration.nix" ''
    {
      nixos.extraModules = [ ({lib, ...}: { system.nixosRevision = lib.mkForce "ABCDEF"; }) ];
    }
  '';

  withPath = pkgs.writeText "configuration.nix" ''
    {
      nixos.path = ${src}/nixos ;
      nixos.extraModules = [ ({lib, ...}: { system.nixosRevision = lib.mkForce "ABCDEF"; }) ];
    }
  '';

  phases = "buildPhase";
  buildPhase = ''
    datadir="${pkgs.nix}/share"
    export TEST_ROOT=$(pwd)/test-tmp
    export NIX_STORE_DIR=$TEST_ROOT/store
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_DB_DIR=$TEST_ROOT/db
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_MANIFESTS_DIR=$TEST_ROOT/var/nix/manifests
    export NIX_BUILD_HOOK=
    export PAGER=cat
    cacheDir=$TEST_ROOT/binary-cache
    nix-store --init

    export NIX_PATH="nixpkgs=$src:nixos=$src/nixos:nixos-config=${withoutPath}" ;
    if test $(nix-instantiate $src/nixos -A config.system.nixosRevision --eval-only) != '"ABCDEF"' ; then :;
    else
      echo "Unexpected re-entry without the nixos.path option defined.";
      exit 1;
    fi;

    export NIX_PATH="nixpkgs=$src:nixos=$src/nixos:nixos-config=${withPath}" ;
    if test $(nix-instantiate $src/nixos -A config.system.nixosRevision --eval-only) = '"ABCDEF"' ; then :;
    else
      echo "Expected a re-entry when the nixos.path option is defined.";
      exit 1;
    fi;

    touch $out;
  '';
}
