{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2024-07-02";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "31905f3e790e63cd0f2366526afe41fb278c226e";
    hash = "sha256-IhGZGHV/A1m653WlVCwxtb9OZbMolQ3GHOr2fXehjNk=";
  };

  vendorHash = "sha256-5ZsvoIDwxZCGkMRxlCyp2Iv6fcvvpmzG+krz3MZSiTM=";

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
