{ stdenv, buildGoPackage, fetchFromGitHub, curl, libgit2_0_25, ncurses, pkgconfig, readline }:
let
  version = "0.1.0";
in
buildGoPackage {
  name = "grv-${version}";

  buildInputs = [ ncurses readline curl libgit2_0_25 ];
  nativeBuildInputs = [ pkgconfig ];

  goPackagePath = "github.com/rgburke/grv";

  goDeps = ./deps.nix;

  src = fetchFromGitHub {
    owner = "rgburke";
    repo = "grv";
    rev = "v${version}";
    sha256 = "1qd9kq8l29v3gwwls98933bk0rdw44mrbnqgb1r6hm9m6vzjfcn3";
  };

  meta = with stdenv.lib; {
    description = " GRV is a terminal interface for viewing git repositories";
    homepage = https://github.com/rgburke/grv;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
  };
}
