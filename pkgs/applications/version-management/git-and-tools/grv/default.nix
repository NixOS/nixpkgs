{ lib, buildGoPackage, fetchFromGitHub, curl, ncurses, pkg-config, readline
, cmake }:
let
  version = "0.3.2";
in
buildGoPackage {
  pname = "grv";
  inherit version;

  buildInputs = [ ncurses readline curl ];
  nativeBuildInputs = [ pkg-config cmake ];

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

  postConfigure = ''
    cd $NIX_BUILD_TOP/go/src/$goPackagePath
  '';

  buildPhase = ''
    runHook preBuild
    make build-only
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -D grv $out/bin/grv
    runHook postInstall
  '';

  meta = with lib; {
    description = "GRV is a terminal interface for viewing Git repositories";
    homepage = "https://github.com/rgburke/grv";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
  };
}
