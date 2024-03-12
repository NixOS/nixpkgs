{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2024-03-07";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "23cb3a146a8567526b35807c6f16120163c40f98";
    hash = "sha256-1ov9SEyXdRTg9HEN2ASC5QY8ZKlWDdrc9TCMfFHIhCc=";
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
