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
  version = "0-unstable-2025-04-05";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "977e9c99b2c8aea2210e73541955515883931f03";
    hash = "sha256-WFGyXfi3P0xr9bLqhBgtfAjc8fQRrmwSbvlFLPHRi5Q=";
  };

  vendorHash = "sha256-NKGsY/5FqLGbwyW6fVSxictDVhju0+jOJSBXQp3ZhFY=";

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
