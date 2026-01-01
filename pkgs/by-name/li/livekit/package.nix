{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
}:

buildGoModule rec {
  pname = "livekit";
<<<<<<< HEAD
  version = "1.9.6";
=======
  version = "1.9.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "livekit";
    repo = "livekit";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-hDBdxuAWFJr5iAFOjGdUwO7zNgsVmFXIRaII1T5m20Y=";
  };

  vendorHash = "sha256-hgziX88Ty3HYQKgpgu/LqdtzqcfjZktZstsve6jVKk4=";
=======
    hash = "sha256-9di+WCu19cjJXBjtQN29JpGUEFygcIYTJXrdRwSg+TE=";
  };

  vendorHash = "sha256-FM7ORm4loMi06T5eAs8KiKFErcXk4XV8yLQYFy3uBRM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd/server" ];

  postInstall = ''
    mv $out/bin/server $out/bin/livekit-server
  '';

  passthru.tests = nixosTests.livekit;

<<<<<<< HEAD
  meta = {
    description = "End-to-end stack for WebRTC. SFU media server and SDKs";
    homepage = "https://livekit.io/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mgdelacroix ];
=======
  meta = with lib; {
    description = "End-to-end stack for WebRTC. SFU media server and SDKs";
    homepage = "https://livekit.io/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mgdelacroix ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "livekit-server";
  };
}
