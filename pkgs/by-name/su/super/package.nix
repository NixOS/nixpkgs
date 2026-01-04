{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nixosTests,
}:
buildGoModule (finalAttrs: {
  pname = "super";
  version = "0-unstable-2026-01-04";

  src = fetchFromGitHub {
    owner = "brimdata";
    repo = "super";
    rev = "5ea0cb5d6f24c74fae39025a1f11f1096912b548";
    hash = "sha256-owkqNrZEjF4py4Qwq237pGjVawvfWIDdRDIvWvWWZJs=";
  };

  vendorHash = "sha256-yGmQmxr2RzpOOwS7qpdBJysJpsgeWDNFBOws1FQQoM8=";

  subPackages = [
    "cmd/super"
  ];

  passthru.tests = { inherit (nixosTests) super; };

  meta = {
    description = "Analytics database that puts JSON and relational tables on equal footing";
    homepage = "https://superdb.org";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hythera ];
  };
})
