{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  libx11,
  makeWrapper,
  wl-clipboard,
}:

buildGoModule (finalAttrs: {
  pname = "discordo";
  version = "0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "af65e21854ccb4cb39cafebfd6afbd5f4858a9f0";
    hash = "sha256-0Eiil0gaLlgQRcLIa2XbBF95+pGNGzAIiFRJ7X0r/W0=";
  };

  vendorHash = "sha256-g/kGDK0QKZZAGczrXtVskqpsbES+MZGiuqycJ8YO6DA=";

  env.CGO_ENABLED = 1;

  ldflags = [
    "-s"
  ];

  # Clipboard support on X11
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libx11
  ];

  # Clipboard support on Wayland
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    makeWrapper
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/discordo \
      --prefix PATH : ${
        lib.makeBinPath [
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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      arian-d
      siphc
    ];
    mainProgram = "discordo";
  };
})
