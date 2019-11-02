{ stdenv, buildGoPackage, fetchFromGitHub, curl, libgit2, ncurses, pkgconfig, readline }:
let
  version = "0.3.1";
in
buildGoPackage {
  pname = "grv";
  inherit version;

  buildInputs = [ ncurses readline curl libgit2 ];
  nativeBuildInputs = [ pkgconfig ];

  goPackagePath = "github.com/rgburke/grv";

  src = fetchFromGitHub {
    owner = "rgburke";
    repo = "grv";
    rev = "v${version}";
    sha256 = "16ylapsibqrqwx45l4ypr3av07rd1haf10v838mjqsakf8l1xc0b";
    fetchSubmodules = true;
  };

  postPatch = ''
    rm util/update_latest_release.go
  '';

  buildFlagsArray = [ "-ldflags=" "-X main.version=${version}" ];

  meta = with stdenv.lib; {
    description = "GRV is a terminal interface for viewing Git repositories";
    homepage = https://github.com/rgburke/grv;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
  };
}
