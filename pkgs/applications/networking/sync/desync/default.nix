{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name = "desync-${version}";
  version = "0.3.0";
  rev = "v${version}";

  goPackagePath = "github.com/folbricht/desync";

  src = fetchFromGitHub {
    inherit rev;
    owner = "folbricht";
    repo = "desync";
    sha256 = "1h2i6ai7q1mg2ysd3cnas96rb8g0bpp1v3hh7ip9nrfxhlplyyda";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "Content-addressed binary distribution system";
    longDescription = "An alternate implementation of the casync protocol and storage mechanism with a focus on production-readiness";
    homepage = https://github.com/folbricht/desync;
    license = licenses.bsd3;
    platforms = platforms.unix; # windows temporarily broken in 0.3.0 release
    maintainers = [ maintainers.chaduffy ];
  };
}
