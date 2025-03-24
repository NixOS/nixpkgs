{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2025-03-19";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "aa58ee2a8a177f01d39bde7368f017fe0fcf425a";
    hash = "sha256-H+m5HqHGC1DzWgTQ0cyD5uwGLiRrKU3eJZ5M/InNmBg=";
  };

  vendorHash = "sha256-tKY/8JUWNnHXtl305k/azAVsVihjC7TBYpopf/Ocqac=";

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
