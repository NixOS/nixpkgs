{ stdenv, buildGoPackage, fetchFromGitHub, curl, libgit2_0_25, ncurses, pkgconfig, readline }:
let
  version = "0.1.1";
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
    sha256 = "0q9gvxfw48d4kjpb2jx7lg577vazjg0n961y6ija5saja5n16mk2";
  };

  meta = with stdenv.lib; {
    description = " GRV is a terminal interface for viewing git repositories";
    homepage = https://github.com/rgburke/grv;
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ andir ];
  };
}
