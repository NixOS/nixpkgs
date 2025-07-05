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
  version = "0-unstable-2025-06-21";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "635ac3678656f23e21de7b114b41cce4390b3386";
    hash = "sha256-mM5JesCqzPkOp+u/oZABef/CNAwlGACNqmHr7YG0wD4=";
  };

  vendorHash = "sha256-X1/NjLI16U9+UyXMDmogRfIvuYNmWgIJ40uYo7VeTP0=";

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
