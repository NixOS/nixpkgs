{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  xsel,
  wl-clipboard,
}:

buildGoModule (finalAttrs: {
  pname = "discordo";
  version = "0-unstable-2025-06-26";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "d701e7d15ba07457aa41ab1d1d02ce2c565c7736";
    hash = "sha256-E8Et8w8ebDjNKPnPIFHC+Ut2IfOCnNJKRwVFUVNf7+8=";
  };

  vendorHash = "sha256-X1/NjLI16U9+UyXMDmogRfIvuYNmWgIJ40uYo7VeTP0=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
  ];

  # Clipboard support on X11 and Wayland
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/discordo \
      --prefix PATH : ${
        lib.makeBinPath [
          xsel
          wl-clipboard
        ]
      }
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    description = "Lightweight, secure, and feature-rich Discord terminal client";
    homepage = "https://github.com/ayn2op/discordo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ arian-d ];
    mainProgram = "discordo";
  };
})
