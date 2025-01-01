{
  lib,
  buildGoModule,
  fetchFromGitea,
  callPackage,
  nixosTests,
}:

let
  version = "0.14.2";
  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "Klasse-Methode";
    repo = "eintopf";
    rev = "v${version}";
    hash = "sha256-38lVbgAjKsg/yXGFmIdw4KmvfIDCAE3K6qhvza3c+dU=";
  };
  frontend = callPackage ./frontend.nix { inherit src version; };
in

buildGoModule rec {
  pname = "eintopf";
  inherit version src;

  vendorHash = "sha256-ysAgyaewREI8TaMnKH+kh33QT6AN1eLhog35lv7CbVU=";

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

  meta = {
    description = "A calendar for Stuttgart, showing events, groups and places";
    homepage = "https://codeberg.org/Klasse-Methode/eintopf";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.unix;
  };
}
