{
  lib,
  buildGoModule,
  fetchFromGitea,
  callPackage,
  nixosTests,
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
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.revision=${src.rev}"
  ];

  preConfigure = ''
    cp -R ${frontend}/. backstage/
  '';

  preCheck = ''
    # Disable test, requires running Docker daemon
    rm cmd/eintopf/main_test.go
    rm service/email/email_test.go
  '';

  passthru.tests = {
    inherit (nixosTests) eintopf;
  };

  meta = with lib; {
    description = "A calendar for Stuttgart, showing events, groups and places";
    homepage = "https://codeberg.org/Klasse-Methode/eintopf";
    # License is going to change back to AGPL in the next release
    # https://codeberg.org/Klasse-Methode/eintopf/issues/351#issuecomment-2076870
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.unix;
  };
}
