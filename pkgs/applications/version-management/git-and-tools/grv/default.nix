{ stdenv, buildGoPackage, fetchFromGitHub, curl, libgit2, ncurses, pkgconfig, readline }:
let
  version = "0.3.2";
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
    sha256 = "0bpjsk35rlp56z8149z890adnhmxyh743vsls3q86j4682b83kyf";
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
