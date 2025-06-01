{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  xsel,
  wl-clipboard,
}:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2025-05-23";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "af2b0995ba6f6f2df8937cf6a6d5bee3adbc0d0c";
    hash = "sha256-eBdPnpO9fZP7uq2/wVmeMu8Bf9UympsjUHTQlX2XKYw=";
  };

  vendorHash = "sha256-gEwTpt/NPN1+YpTBmW8F34UotowrOcA0mfFgBdVFiTA=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
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

  meta = with lib; {
    description = "Lightweight, secure, and feature-rich Discord terminal client";
    homepage = "https://github.com/ayn2op/discordo";
    license = licenses.mit;
    maintainers = [ maintainers.arian-d ];
    mainProgram = "discordo";
  };
}
