{ stdenv, buildGoPackage, fetchFromGitHub, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "rclone-${version}";
  version = "1.33";

  goPackagePath = "github.com/ncw/rclone";

  src = fetchFromGitHub {
    owner = "ncw";
    repo = "rclone";
    rev = "v${version}";
    sha256 = "00y48ww40x73xpdvkzfhllwvbh9a2ffmmkc6ri9343wvmb53laqk";
  };

  goDeps = ./deps.nix;

  meta = {
    description = "Command line program to sync files and directories to and from major cloud storage";
    homepage = "http://rclone.org";
    license = stdenv.lib.licenses.mit;
    maintainers = [ ];
    platforms = stdenv.lib.platforms.all;
  };
}
