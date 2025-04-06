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
  version = "0-unstable-2025-03-31";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "9e95b18ab7ba021a71f94e7520c1b9e3b73d3c0f";
    hash = "sha256-XxjhLVs87npwuys5FmfMba6dg4NcgRPIieTDgI6UXyk=";
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
