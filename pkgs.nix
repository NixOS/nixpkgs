rec {
  inherit (import pkgs/system/i686-linux.nix) stdenv bash coreutils findutils;
  init = (import ./init) {inherit stdenv bash coreutils findutils;};
}
