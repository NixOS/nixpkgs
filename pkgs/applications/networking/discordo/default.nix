{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2023-12-12";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "320ec7753d552974d4d5ede3fcf6fb3c0d52b6e4";
    hash = "sha256-LVWOXw8+GbCE6N6kVSXDjjNqOcq7PS4KU7LXoowhBdQ=";
  };

  vendorHash = "sha256-8qr1erKGyJvR4LDKHkZf7nR0tQOcvUHQyJt7OlqNS44=";

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
