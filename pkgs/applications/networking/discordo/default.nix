{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2024-02-25";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "6e683a6526279a8c0f9f8a03be776d62214a4d13";
    hash = "sha256-sPNJkzVulgbm3OdJWSj6i2YOKin9VO0L3aS2c0alwBE=";
  };

  vendorHash = "sha256-dBJYTe8aZtNuBwmcpXb3OEHoLVCa/GbGExLIRc8cVbo=";

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
