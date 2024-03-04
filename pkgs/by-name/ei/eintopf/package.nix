{ lib
, buildGoModule
, fetchFromGitea
, callPackage
}:
let
  version = "0.13.16";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Klasse-Methode";
    repo = "eintopf";
    rev = "v${version}";
    hash = "sha256-ex5bpO60ousJcgZGdviqWrCyihycW+JT+EYFvdooUDw=";
  };
  frontend = callPackage ./frontend.nix { inherit src version; };
in
buildGoModule rec {
  pname = "eintopf";
  inherit version src;

  vendorHash = "sha256-dBxI6cUGc16lg89x8b+hSLcv5y/MLf6vDIvqdMBUz3I=";

  ldflags = [
    "-s" "-w" "-X main.version=${version} -X main.revision=${src.rev}"
  ];

  preConfigure = ''
    cp -R ${frontend}/. backstage/
  '';

  # FIXME
  doCheck = false;

  meta = with lib; {
    description = "A calendar for Stuttgart, showing events, groups and places";
    homepage = "https://codeberg.org/Klasse-Methode/eintopf";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.unix;
  };
}

