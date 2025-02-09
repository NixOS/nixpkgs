{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2025-02-08";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "ea51fac7d6ea0fcb48decac8600d82e39a6879dd";
    hash = "sha256-pQjukqycdiMG9aCk37+LKZXlJPxgi8ZrI0G5Tsnv9xg=";
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
