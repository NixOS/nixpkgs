{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2025-01-12";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "2f071695146188c65b51f7030a89addfa845469a";
    hash = "sha256-k2wwFx0Wi60xpdiS7qGoHdS6TfXFlI6yDeXXfOp1ivc=";
  };

  vendorHash = "sha256-FsZRh4k9ucmAruJa1MZ4kVVryrEuHy9StgXHvgBiWSg=";

  env.CGO_ENABLED = 0;

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
