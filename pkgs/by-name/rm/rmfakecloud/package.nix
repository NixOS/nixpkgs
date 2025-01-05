{
  lib,
  fetchFromGitHub,
  buildGoModule,
  callPackage,
  enableWebui ? true,
  nixosTests,
}:

buildGoModule rec {
  pname = "rmfakecloud";
  version = "0.0.21";

  src = fetchFromGitHub {
    owner = "ddvk";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Opx39FUo4Kzezi96D9iraA8gkqCPVfMf4LhxtVpsuNQ=";
  };

  vendorHash = "sha256-9tfxE03brUvCYusmewiqNpCkKyIS9qePqylrzDWrJLY=";

  ui = callPackage ./webui.nix { inherit version src; };

  postPatch =
    if enableWebui then
      ''
        mkdir -p ui/build
        cp -r ${ui}/* ui/build
      ''
    else
      ''
        sed -i '/go:/d' ui/assets.go
      '';

  ldflags = [
    "-s"
    "-w"
    "-X main.version=v${version}"
  ];

  passthru.tests.rmfakecloud = nixosTests.rmfakecloud;

  meta = with lib; {
    description = "Host your own cloud for the Remarkable";
    homepage = "https://ddvk.github.io/rmfakecloud/";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      euxane
      martinetd
    ];
    mainProgram = "rmfakecloud";
  };
}
