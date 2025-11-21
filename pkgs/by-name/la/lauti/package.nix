{
  lib,
  buildGoModule,
  fetchFromGitea,
  callPackage,
  nixosTests,
}:

let
  version = "1.1.0";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Klasse-Methode";
    repo = "lauti";
    tag = "v${version}";
    hash = "sha256-eYIKVQG+Vj2qld/xKbxx0JpNqKhnGSjIOXXc7400BYo=";
  };
  frontend = callPackage ./frontend.nix { inherit src version; };
in

buildGoModule rec {
  pname = "lauti";
  inherit version src;

  vendorHash = "sha256-4LQ3PvwWAg+/KBQHroj2ZVQZst7jPq99XwLTHClDPCU=";

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
    rm cmd/lauti/main_test.go
    rm service/email/email_test.go
  '';

  passthru.tests = {
    inherit (nixosTests) lauti;
  };

  meta = {
    description = "Open source calendar for events, groups and places";
    homepage = "https://lauti.org";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.unix;
    mainProgram = "lauti";
  };
}
