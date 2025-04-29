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
  version = "0-unstable-2025-04-19";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "c6c66c31ba0af106d45132bcf5e14540d54f24d0";
    hash = "sha256-AYi9biVjJatG8lEGj1oJvukre+ZbFePyBZIYc5aMpXY=";
  };

  vendorHash = "sha256-NZlIZYytk3OKtIdEwVInnQhORL1iSzuWzmZjrknD71E=";

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
