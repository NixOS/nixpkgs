{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "desync-${version}";
  version = "0.4.0";
  rev = "v${version}";

  goPackagePath = "github.com/folbricht/desync";

  src = fetchFromGitHub {
    inherit rev;
    owner = "folbricht";
    repo = "desync";
    sha256 = "17qh0g1paa7212j761q9z246k10a3xrwd8fgiizw3lr9adn50kdk";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Content-addressed binary distribution system";
    longDescription = "An alternate implementation of the casync protocol and storage mechanism with a focus on production-readiness";
    homepage = https://github.com/folbricht/desync;
    license = licenses.bsd3;
    platforms = platforms.unix; # *may* work on Windows, but varies between releases.
    maintainers = [ maintainers.chaduffy ];
  };
}
