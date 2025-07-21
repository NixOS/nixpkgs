{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  xsel,
  wl-clipboard,
}:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2025-07-20";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "5217df9d9793cc0983eda74e99df14a8476fc30d";
    hash = "sha256-fDB8YI9TmL3MPq2TL1remAR2sW4BQgq0G/0eSUemceQ=";
  };

  vendorHash = "sha256-HmDCnZ2Dvy6e3rthmRMIB37XJ5MMuaATYd2R+IRcIIg=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
  ];

  # Clipboard support on X11 and Wayland
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/discordo \
      --prefix PATH : ${
        lib.makeBinPath [
          xsel
          wl-clipboard
        ]
      }
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "Lightweight, secure, and feature-rich Discord terminal client";
    homepage = "https://github.com/ayn2op/discordo";
    license = licenses.mit;
    maintainers = [ maintainers.arian-d ];
    mainProgram = "discordo";
  };
}
