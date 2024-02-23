{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2024-02-21";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "3486f6ced9db8eb865641632e50daa2550a55ef8";
    hash = "sha256-iSc9WiX0xu9X1GCSPEnf99OpTaKVlNN7sGp+f1S89SM=";
  };

  vendorHash = "sha256-89WJZuqUnYGT2eTWcfxdouwc2kZ15Lt38EyLP/DLSWI=";

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
