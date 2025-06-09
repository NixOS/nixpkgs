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
  version = "0-unstable-2025-06-03";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "23be8cd23591d3076712dd6c7c0b9e20571e1545";
    hash = "sha256-hbgCxu48c+glnLN8jEAzFrOwxYxAdap3TaqKKtYtzqE=";
  };

  vendorHash = "sha256-Kx0dI53ordvsSY0GCp6H+1XiSBAHXLbcg0tQJVa86uw=";

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
