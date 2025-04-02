{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "livekit-cli";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit-cli";
    rev = "v${version}";
    hash = "sha256-Ta6IAkx84BBF3xptFYju6XGyYb67mx9PTADnlOGa1D0=";
  };

  vendorHash = "sha256-hLaH9/ylA+MHaFaS64jOZOyg3AxDziL5y/tOjxQglKk=";

  subPackages = [ "cmd/lk" ];

  meta = with lib; {
    description = "Command line interface to LiveKit";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mgdelacroix ];
    mainProgram = "lk";
  };
}
