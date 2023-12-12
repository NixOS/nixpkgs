{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2023-12-11";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "9c9ea0dc2fdd4ca18c68b08585bcc5b276388d62";
    hash = "sha256-6gGbro4OsPh+HK9GR01uOUN80lgwMd7oLq9ASWtpNoY=";
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
