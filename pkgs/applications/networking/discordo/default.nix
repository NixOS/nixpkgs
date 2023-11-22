{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2023-11-14";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "002e382c0de1d87e2ce7fd579346da4f339880ca";
    hash = "sha256-eOlPc2WDjc73UlFH9d6Kw4/nEbjhBv4xLopxdTnFTYk=";
  };

  vendorHash = "sha256-1evMzQECqZvKJzNUk9GjrQej9vmnHs9Fm4kXJ0i5gMw=";

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
  };
}
