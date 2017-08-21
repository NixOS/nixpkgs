{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  version = "1.20170611";
  pname   = "blackbox";
  name    = "${pname}-${version}";

  src = fetchFromGitHub {
    owner  = "stackexchange";
    repo   = pname;
    rev    = "v${version}";
    sha256 = "1jnzhlj54c0szw9l9wib07i2375pbm402bx9wagspcmwc0qw43p6";
  };

  installPhase = ''
    mkdir -p $out/bin && cp -r bin/* $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Safely store secrets in a VCS repo";
    maintainers = with maintainers; [ ericsagnes ];
    license     = licenses.mit;
    platforms   = platforms.all;
  };
}
