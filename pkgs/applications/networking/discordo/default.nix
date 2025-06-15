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
  version = "0-unstable-2025-06-12";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "ea5abfdcd67298086a6eb8fc84b7b622b6ab3496";
    hash = "sha256-Srm1nEiY4DiZB2Ogj1jzvB+9pmJRcBYLvlikANa7FHM=";
  };

  vendorHash = "sha256-4iBMRcnOWCGz6QkYY7mmgKFw6c5LR25sZaRVm7wreOM=";

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
