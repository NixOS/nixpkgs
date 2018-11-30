{ stdenv, buildGo19Package, fetchFromGitHub, curl, libgit2_0_27, ncurses, pkgconfig, readline }:
let
  version = "0.3.0";
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
    sha256 = "00v502mwnpv09l7fsbq3s72i5fz5dxbildwxgw0r8zzf6d54xrgl";
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
