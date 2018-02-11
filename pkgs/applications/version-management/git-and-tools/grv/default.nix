{ stdenv, buildGoPackage, fetchFromGitHub, curl, libgit2_0_25, ncurses, pkgconfig, readline }:
let
  version = "0.1.2";
in
buildGoPackage {
  name = "grv-${version}";

  buildInputs = [ ncurses readline curl libgit2_0_25 ];
  nativeBuildInputs = [ pkgconfig ];

  goPackagePath = "github.com/rgburke/grv";

  src = fetchFromGitHub {
    owner = "rgburke";
    repo = "grv";
    rev = "v${version}";
    sha256 = "1i8cr5xxdacpby60nqfyj8ijyc0h62029kbds2lq26rb8nn9qih2";
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
