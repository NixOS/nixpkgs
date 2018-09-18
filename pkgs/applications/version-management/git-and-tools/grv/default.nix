{ stdenv, buildGo19Package, fetchFromGitHub, curl, libgit2_0_27, ncurses, pkgconfig, readline }:
let
  version = "0.2.0";
in
buildGo19Package {
  name = "grv-${version}";

  buildInputs = [ ncurses readline curl libgit2_0_27 ];
  nativeBuildInputs = [ pkgconfig ];

  goPackagePath = "github.com/rgburke/grv";

  src = fetchFromGitHub {
    owner = "rgburke";
    repo = "grv";
    rev = "v${version}";
    sha256 = "0hlqw6b51jglqzzjgazncckpgarp25ghshl0lxv1mff80jg8wd1a";
    fetchSubmodules = true;
  };

  buildFlagsArray = [ "-ldflags=" "-X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = " GRV is a terminal interface for viewing git repositories";
    homepage = https://github.com/rgburke/grv;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
  };
}
