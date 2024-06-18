{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "aiac";
  version = "4.3.0";
  excludedPackages = [".ci"];

  src = fetchFromGitHub {
    owner = "gofireflyio";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-6u/TVCLFtcNzmchYw8dhedNRm7Lpl9oi8MpYkLYzFdg=";
  };

  vendorHash = "sha256-JWQQUB4/yIDGzWeshtcWnkXQS7jYcDHwG/tef6sBizQ=";
  ldflags = [ "-s" "-w" "-X github.com/gofireflyio/aiac/v4/libaiac.Version=v${version}" ];

  meta = with lib; {
    description = ''Artificial Intelligence Infrastructure-as-Code Generator.'';
    mainProgram = "aiac";
    homepage = "https://github.com/gofireflyio/aiac/";
    license = licenses.asl20;
    maintainers = with maintainers; [ qjoly ];
  };
}
