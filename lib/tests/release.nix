{ pkgs ? import ((import ../.).cleanSource ../..) {} }:

pkgs.stdenv.mkDerivation {
  name = "nixpkgs-lib-tests";
  buildInputs = [ pkgs.nix ];
  NIX_PATH="nixpkgs=${pkgs.path}";

  buildCommand = ''
    datadir="${pkgs.nix}/share"
    export TEST_ROOT=$(pwd)/test-tmp
    export NIX_BUILD_HOOK=
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_DB_DIR=$TEST_ROOT/db
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_MANIFESTS_DIR=$TEST_ROOT/var/nix/manifests
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_STORE_DIR=$TEST_ROOT/store
    export PAGER=cat
    cacheDir=$TEST_ROOT/binary-cache
    nix-store --init

    cd ${pkgs.path}/lib/tests
    ./modules.sh

    [[ "$(nix-instantiate --eval --strict misc.nix)" == "[ ]" ]]

    [[ "$(nix-instantiate --eval --strict systems.nix)" == "[ ]" ]]

    touch $out
  '';
}
