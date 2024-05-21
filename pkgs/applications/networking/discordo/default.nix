{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2024-04-27";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "d76a7db668900a7fc41ead7db194e20f126071ac";
    hash = "sha256-uEMz7n0IFTGK1fZC1/vuwJpyySGdTUIMUjunCmycnzM=";
  };

  vendorHash = "sha256-hSrGN3NHPpp5601l4KcmNHVYOGWfLjFeWWr9g11nM3I=";

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
