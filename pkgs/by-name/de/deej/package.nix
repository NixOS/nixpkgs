{ lib,
  buildGoModule,
  fetchFromGitHub,
  pkg-config,
  libappindicator-gtk3,
  webkitgtk
}:

buildGoModule rec {
  pname = "deej";
  version = "0.9.10";
  rev = "7567f83f2773e40cb950101d0784c96b1e566509";

  src = fetchFromGitHub {
    owner = "omriharel";
    repo = "deej";
    rev = "v${version}";
    hash = "sha256-T6S3FQ9vxl4R3D+uiJ83z1ueK+3pfASEjpRI+HjIV0M=";
  };

  vendorHash = "sha256-1gjFPD7YV2MTp+kyC+hsj+NThmYG3hlt6AlOzXmEKyA=";

  ldflags = [
    "-X main.versionTag=v${version}"
    "-X main.gitCommit=${rev}"
    "-X main.buildType=nix-release"
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libappindicator-gtk3 webkitgtk ];
  postInstall = "mv $out/bin/cmd $out/bin/deej";

  meta = with lib; {
    description = "An open-source hardware volume mixer";
    longDescription = ''
      deej is an open-source hardware volume mixer for Windows and Linux PCs.
      It lets you use real-life sliders (like a DJ!) to seamlessly control the volumes
      of different apps (such as your music player, the game you're playing and your voice
      chat session) without having to stop what you're doing.
    '';

    homepage = "https://github.com/omriharel/deej";
    maintainers = with maintainers; [ lzszt ];
    license = licenses.mit;

    mainProgram = "deej";
  };
}
