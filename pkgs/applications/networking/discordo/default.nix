{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2024-10-13";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "26b77d9385daa2dc056930fa302a3c06595680ba";
    hash = "sha256-zXqYj8IBDVeDKjm0m8CYEX+tmHLpY2u7A4g38IiDNZk=";
  };

  vendorHash = "sha256-68NGcdyKuabSdW6CKAJUaJ0k2dpO0bm3OfNQ7qEVcqk=";

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
