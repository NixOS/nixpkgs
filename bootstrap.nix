let {
  pkgs = import pkgs/system/i686-linux.nix;
  body = pkgs.bash;
}