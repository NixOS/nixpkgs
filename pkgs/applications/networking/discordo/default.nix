{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2024-03-12";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "5805f6605efe63fc887e850bcc5d107070eb2c1a";
    hash = "sha256-IzVDxylrR0X8HLWTelSBq2+uu2h2Jd6iaNUXh9zQ9Yk=";
  };

  vendorHash = "sha256-6pCQHr/O2pfR1v8YI+htwGZ8RFStEEUctIEpgblXvjY=";

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
    description = "A lightweight, secure, and feature-rich Discord terminal client";
    homepage = "https://github.com/ayn2op/discordo";
    license = licenses.mit;
    maintainers = [ maintainers.arian-d ];
    mainProgram = "discordo";
  };
}
