{ callPackage }:

let
  common = opts: callPackage (import ./common.nix opts);
in {
  sublime-merge = common {
    buildVersion = "2032";
    sha256 = "b782c768383893ba7803c2cffd428b09bec46be8a65e61a5f17964bdcc2aaf7c";
  } {};

  sublime-merge-dev = common {
    buildVersion = "2037";
    sha256 = "1s0g18l2msmnn6w7f126andh2dygm9l94fxxhsi64v74mkawqg82";
    dev = true;
  } {};
}
