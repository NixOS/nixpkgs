{
  lib,
  buildGoModule,
  fetchFromGitea,
  callPackage,
  nixosTests,
}:

let
  version = "1.0.0";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Klasse-Methode";
    repo = "lauti";
    tag = "v${version}";
    hash = "sha256-cO9rK7GAVRlv5x4WI/xbXNJ594QqB+KIPUteB3TifKM=";
  };
  frontend = callPackage ./frontend.nix { inherit src version; };
in

buildGoModule rec {
  pname = "lauti";
  inherit version src;

  vendorHash = "sha256-ushTvIpvRLZP3q6tLN6BA4tl2Xp/UImWugm2ZgTAm8k=";

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
    description = "An open source calendar for events, groups and places";
    homepage = "https://lauti.org";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.unix;
    mainProgram = "lauti";
  };
}
