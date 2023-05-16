{ lib, buildGoModule, fetchFromGitHub, runtimeShell }:

buildGoModule rec {
  pname = "hivemind";
  version = "1.1.0";

  postPatch = ''
    substituteInPlace process.go --replace \"/bin/sh\" \"${runtimeShell}\"
  '';

  src = fetchFromGitHub {
    owner = "DarthSim";
    repo = "hivemind";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-YUR9OwRuH1xSPs8iTsSIjLCt2TyYH357IAYULGTyYUc=";
  };

  vendorHash = "sha256-KweFhT8Zueg45Q/vw3kNET35hB+0WbUPfz0FYaAiIA8=";
=======
    sha256 = "YUR9OwRuH1xSPs8iTsSIjLCt2TyYH357IAYULGTyYUc=";
  };
  vendorSha256 = "KweFhT8Zueg45Q/vw3kNET35hB+0WbUPfz0FYaAiIA8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/DarthSim/";
    description = "Process manager for Procfile-based applications";
    license = with licenses; [ mit ];
    maintainers = [ maintainers.sveitser ];
  };
}
