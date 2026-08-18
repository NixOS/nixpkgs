{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule (finalAttrs: {
  pname = "lightning-pool";
  version = "0.7.0-beta";

  src = fetchFromGitHub {
    owner = "lightninglabs";
    repo = "pool";
    rev = "v${finalAttrs.version}";
    hash = "sha256-jhHshr8THkact/xTVPoD5GyDxj+Cot7fFU8riPMSsYg=";
  };

  vendorHash = "sha256-zl6KwVWwk6uFPqMEd7e0pw3TbtP8IEwTaVJZd59dHTA=";

  subPackages = [
    "cmd/pool"
    "cmd/poold"
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "Lightning Pool Client";
    homepage = "https://github.com/lightninglabs/pool";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ proofofkeags ];
  };
})
