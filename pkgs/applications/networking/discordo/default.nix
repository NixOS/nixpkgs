{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2023-09-16";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "d3cdbe480392dbab6ddc099d7d880378f6a13f26";
    hash = "sha256-noCwPhp5/wYt28TM1vvsXb0ewRMV/cMzu/zUD2b0YV4=";
  };

  vendorHash = "sha256-5Y+SP374Bd8F2ABKEKRhTcGNhsFM77N5oC5wRN6AzKk=";

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
