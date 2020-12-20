{ stdenv, buildGoPackage, fetchFromGitHub }:

# Upstream has a `./vendor` directory with all deps which we rely upon.
buildGoPackage rec {
  pname = "tty-share";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "elisescu";
    repo = "tty-share";
    rev = "v${version}";
    sha256 = "1d2vd3d1lb4n0jq4s0p5mii1vz4r3z36hykr5mnx53srsni1wsj5";
  };

  goPackagePath = "github.com/elisescu/tty-share";

  meta = with stdenv.lib; {
    homepage = "https://tty-share.com";
    description = "Share terminal via browser for remote work or shared sessions";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ andys8 ];
  };
}
