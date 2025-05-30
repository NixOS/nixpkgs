{
  lib,
  expect,
  nix,
  nixos-rebuild-ng,
  path,
  runCommand,
  stdenv,
  writeText,
}:
let
  # Arguably not true, but it holds up for now.
  escapeExpect = lib.strings.escapeNixString;

  expectSetup = ''
    set timeout 300
    proc expect_simple { pattern } {
      puts "Expecting: $pattern"
      expect {
        timeout {
          puts "\nTimeout waiting for: $pattern\n"
          exit 1
        }
        $pattern
      }
    }
  '';

  # In case we want/need to evaluate packages or the assertions or whatever,
  # we want to have a linux system.
  # TODO: make the non-flake test use this.
  linuxSystem = lib.replaceStrings [ "darwin" ] [ "linux" ] stdenv.hostPlatform.system;

in
runCommand "test-nixos-rebuild-repl"
  {
    nativeBuildInputs = [
      expect
      nix
      (nixos-rebuild-ng.override { withNgSuffix = false; })
    ];

    nixpkgs = if builtins.pathExists (path + "/.git") then lib.cleanSource path else path;
  }
  ''
    export HOME=$(mktemp -d)
    export TEST_ROOT=$PWD/test-tmp

    # Prepare for running Nix in sandbox
    export NIX_BUILD_HOOK=
    export NIX_CONF_DIR=$TEST_ROOT/etc
    export NIX_LOCALSTATE_DIR=$TEST_ROOT/var
    export NIX_LOG_DIR=$TEST_ROOT/var/log/nix
    export NIX_STATE_DIR=$TEST_ROOT/var/nix
    export NIX_STORE_DIR=$TEST_ROOT/store
    export PAGER=cat
    mkdir -p $TEST_ROOT $NIX_CONF_DIR

    echo General setup
    ##################

    export NIX_PATH=nixpkgs=$nixpkgs:nixos-config=$HOME/configuration.nix
    cat >> ~/configuration.nix <<EOF
    {
      boot.loader.grub.enable = false;
      fileSystems."/".device = "x";
      imports = [ ./hardware-configuration.nix ];
    }
    EOF

    echo '{ }' > ~/hardware-configuration.nix


    echo Test traditional NixOS configuration
    #########################################

    expect ${writeText "test-nixos-rebuild-repl-expect" ''
      ${expectSetup}
      spawn nixos-rebuild repl --no-reexec

      expect "nix-repl> "

      send "config.networking.hostName\n"
      expect "\"nixos\""
    ''}


    echo Test flake based NixOS configuration
    #########################################

    # Switch to flake flavored environment
    unset NIX_PATH
    cat > $NIX_CONF_DIR/nix.conf <<EOF
    experimental-features = nix-command flakes
    EOF

    # Make the config pure
    echo '{ nixpkgs.hostPlatform = "${linuxSystem}"; }' > ~/hardware-configuration.nix

    cat >~/flake.nix <<EOF
    {
      inputs.nixpkgs.url = "path:$nixpkgs";
      outputs = { nixpkgs, ... }: {
        nixosConfigurations.testconf = nixpkgs.lib.nixosSystem {
          modules = [
            ./configuration.nix
            # Let's change it up a bit
            { networking.hostName = "itsme"; }
          ];
        };
      };
    }
    EOF

    # cat -n ~/flake.nix

    expect ${writeText "test-nixos-rebuild-repl-absolute-path-expect" ''
      ${expectSetup}
      spawn sh -c "nixos-rebuild repl --no-reexec --flake path:\$HOME#testconf"

      expect_simple "nix-repl>"

      send "config.networking.hostName\n"
      expect_simple "itsme"

      expect_simple "nix-repl>"
      send "lib.version\n"
      expect_simple ${
        escapeExpect (
          # The version string is a bit different in the flake lib, so we expect a prefix and ignore the rest
          # Furthermore, including the revision (suffix) would cause unnecessary rebuilds.
          # Note that a length of 4 only matches e.g. "24.
          lib.strings.substring 0 4 (lib.strings.escapeNixString lib.version)
        )
      }

      # Make sure it's the right lib - should be the flake lib, not Nixpkgs lib.
      expect_simple "nix-repl>"
      send "lib?nixosSystem\n"
      expect_simple "true"
      expect_simple "nix-repl>"
      send "lib?nixos\n"
      expect_simple "true"
    ''}

    pushd "$HOME"
    expect ${writeText "test-nixos-rebuild-repl-relative-path-expect" ''
      ${expectSetup}
      spawn sh -c "nixos-rebuild repl --no-reexec --flake .#testconf"

      expect_simple "nix-repl>"

      send "config.networking.hostName\n"
      expect_simple "itsme"
    ''}
    popd

    echo

    #########
    echo Done
    touch $out
  ''
