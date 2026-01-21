{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "ruler";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "sensepost";
    repo = "ruler";
    tag = version;
    hash = "sha256-cEYpK1LB9b65xr6MCMax1vUtSWefjJdXNs4sPgx65d0=";
  };

  vendorHash = "sha256-ITd3cvZmRBWK3922dDRvNHNH8KzHoVfIQI6S318ibxA=";

  ldflags = [
    "-w"
    "-s"
  ];

  meta = {
    description = "Tool to abuse Exchange services";
    homepage = "https://github.com/sensepost/ruler";
    changelog = "https://github.com/sensepost/ruler/releases/tag/${version}";
    license = with lib.licenses; [ cc-by-nc-40 ];
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "ruler";
  };
}
