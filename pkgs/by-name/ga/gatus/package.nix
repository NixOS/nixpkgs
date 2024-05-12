{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "gatus";
  version = "5.10.0";

  src = fetchFromGitHub {
    owner = "TwiN";
    repo = "gatus";
    rev = "v${version}";
    hash = "sha256-gZSK3ebBBJGHRdylCl18AYifGknYbOz7+xaCJjU9ZlY=";
  };

  vendorHash = "sha256-sZ6IPYitNnnw7+UQVAWFEe9/ObDhAiou1GzDDqnGXb8=";

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
