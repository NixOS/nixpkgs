{
  lib,
  pkgs,
  evalSystem,
}:
let
  eval = evalSystem {
    system.stateVersion = "26.11";
    boot.loader.grub.enable = false;
    fileSystems."/" = {
      device = "nodev";
      fsType = "tmpfs";
    };
    services.nodebb = {
      enable = true;
      database = {
        type = "mongo";
        createLocally = true;
        passwordFile = "/dev/null";
      };
      admin = {
        username = "admin";
        email = "admin@example.com";
        passwordFile = "/dev/null";
      };
    };
  };
  failed = builtins.filter (a: !a.assertion) eval.config.assertions;
in
assert lib.any (a: lib.hasInfix "MongoDB" a.message) failed;
pkgs.runCommand "nodebb-mongo-createlocally-fails" { } "touch $out"
