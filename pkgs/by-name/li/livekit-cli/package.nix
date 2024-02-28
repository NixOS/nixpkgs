{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "livekit-cli";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    rev = "v${version}";
    hash = "sha256-u6tqrh2Au4XL590EqD3WInQbN6H6GzRoaA3Uke94Y60=";
  };

  vendorHash = "sha256-PCZNFt08Ad+pjKrl7KZy7jUhu/fWO3raoQM0abCpaGs=";

  subPackages = [ "cmd/livekit-cli" ];

  meta = with lib; {
    description = "Command line interface to LiveKit";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mgdelacroix ];
    mainProgram = "livekit-cli";
  };
}
