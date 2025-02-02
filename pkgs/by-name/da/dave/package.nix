{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "dave";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "micromata";
    repo = "dave";
    rev = "v${version}";
    hash = "sha256-JgRclcSrdgTXBuU8attSbDhRj4WUGXSpKTrUZ8mP5ns=";
  };

  vendorHash = "sha256-yo6DEvKnCQak+MrpIIDU4DkRhRP+HeJXLV87NRf6g/c=";

  subPackages = [
    "cmd/dave"
    "cmd/davecli"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.builtBy=nixpkgs"
  ];

  meta = {
    homepage = "https://github.com/micromata/dave";
    description = "Totally simple and very easy to configure stand alone webdav server";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ lunik1 ];
    mainProgram = "dave";
  };
}
