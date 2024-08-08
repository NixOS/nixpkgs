{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "spirit";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "cashapp";
    repo = "spirit";
    rev = "v${version}-prerelease";
    hash = "sha256-olXEFyKp4E3x+5rFu3A8jJ5ZRb/ajPl/MMFrhlI9mx0=";
  };

  vendorHash = "sha256-lPLThYSyLsVioKTwvAmGU8PdmPfZaMyJUYG8J2/RZ7Q=";

  subPackages = [ "cmd/spirit" ];

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    homepage = "https://github.com/cashapp/spirit";
    description = "Online schema change tool for MySQL";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "spirit";
  };
}
