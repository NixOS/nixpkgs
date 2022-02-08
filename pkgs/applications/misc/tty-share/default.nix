{ lib, buildGoPackage, fetchFromGitHub }:

# Upstream has a `./vendor` directory with all deps which we rely upon.
buildGoPackage rec {
  pname = "tty-share";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "elisescu";
    repo = "tty-share";
    rev = "v${version}";
    sha256 = "sha256-aAqKfi0ZX0UB07yGY6x0HcMspvq4rcJXKHSONxAwMlc=";
  };

  goPackagePath = "github.com/elisescu/tty-share";

  meta = with lib; {
    homepage = "https://tty-share.com";
    description = "Share terminal via browser for remote work or shared sessions";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ andys8 ];
  };
}
