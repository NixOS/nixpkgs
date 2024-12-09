{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2024-11-30";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "3286ebecaab3c05ddbab9e6b502a750d07cea5aa";
    hash = "sha256-DaD6Rv/dzky3gjjqtjObTFZp7EJ8+UK6CoFpqZ/HO9U=";
  };

  vendorHash = "sha256-66Y5hmEEQUBsSfYaj6UzCsFhDkwCDs6y2WOsnYby1gE=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  # Clipboard support on X11 and Wayland
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/discordo \
      --prefix PATH : ${lib.makeBinPath [ xsel wl-clipboard ]}
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
