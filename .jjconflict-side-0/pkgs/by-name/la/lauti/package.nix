{
  lib,
  buildGoModule,
  fetchFromCodeberg,
  callPackage,
  nixosTests,
}:

let
  version = "1.2.0";
  src = fetchFromCodeberg {
    owner = "Klasse-Methode";
    repo = "lauti";
    tag = "v${version}";
    hash = "sha256-llmXXaCy6V4DE0B1a0K0rRCb6XSvC1+EaG9legx0u4I=";
  };
  frontend = callPackage ./frontend.nix { inherit src version; };
in

buildGoModule rec {
  pname = "lauti";
  inherit version src;

  vendorHash = "sha256-XO2Fo4rH6YDlj8x9f0847OEBLLpLlzFpK72uOEgW65o=";

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
