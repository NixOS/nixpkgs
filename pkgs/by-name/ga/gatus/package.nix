{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gatus";
  version = "5.7.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-GG5p2sAIameGo6IFt3IBwFuLfVFRbfHjrQrG6Ei9odA=";
  };

  vendorHash = "sha256-VYHBqVFXX7fUuW2UqPOlbRDEfcysYvjSlfm0UJ2mMGM=";

  subPackages = [ "." ];

  meta = with lib;
    {
      description = "Automated developer-oriented status page";
      homepage = "https://gatus.io";
      license = licenses.asl20;
      maintainers = with maintainers; [ undefined-moe ];
      mainProgram = "gatus";
    };
}
