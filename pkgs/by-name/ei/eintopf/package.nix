{ lib
, buildGoModule
, fetchFromGitea
, callPackage
, nixosTests
}:

let
  version = "0.14.1";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Klasse-Methode";
    repo = "eintopf";
    rev = "v${version}";
    hash = "sha256-+QEAUyAqFLcc3bhGI3v4FxhDt+3P6vBnxWsFPp56lfg=";
  };
  frontend = callPackage ./frontend.nix { inherit src version; };
in

buildGoModule rec {
  pname = "eintopf";
  inherit version src;

  vendorHash = "sha256-ODVCZWxkPWW8ZlONiVXwVQalsLIUl9x512JimLAUm6U=";

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
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.unix;
  };
}

