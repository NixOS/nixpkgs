{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "ddns-go";
  version = "6.13.2";

  src = fetchFromGitHub {
    owner = "jeessy2";
    repo = "ddns-go";
    rev = "v${version}";
    hash = "sha256-Jko5cVcCMrBsfcOOSh6ETlk1jdTCbSj1zOgTwhXnxzQ=";
  };

  vendorHash = "sha256-URPCqItQ/xg8p0EdkMS6z8vuSJ1YaCicsvyb+Jvj2CU=";

  ldflags = [
    "-X main.version=${version}"
  ];

  # network required
  doCheck = false;

  passthru.tests = { inherit (nixosTests) ddns-go; };

  meta = with lib; {
    homepage = "https://github.com/jeessy2/ddns-go";
    description = "Simple and easy to use DDNS";
    license = licenses.mit;
    maintainers = with maintainers; [ oluceps ];
    mainProgram = "ddns-go";
  };
}
