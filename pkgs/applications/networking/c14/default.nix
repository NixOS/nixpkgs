{ stdenv, buildGoPackage, fetchgit }:

buildGoPackage rec {
  name = "c14-cli-${version}";
  version = "20160909-${stdenv.lib.strings.substring 0 7 rev}";
  rev = "e7c7c3cb214fd06df63530a4e861210e7a0a1b6c";

  goPackagePath = "github.com/online-net/c14-cli";
  subPackages = [ "cmd/c14" ];
  
  src = fetchgit {
    inherit rev;
    url = "https://github.com/online-net/c14-cli";
    sha256 = "1k53lii2c04j8cy1bnyfvckl9fglprxp75cmbg15lrp9iic2w22a";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "C14 is designed for data archiving & long-term backups.";
    homepage = "https://www.online.net/en/c14";
    license = licenses.mit;
    maintainers = with maintainers; [ 41px ];
  };
}
