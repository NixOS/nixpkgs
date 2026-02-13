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
  version = "0-unstable-2026-02-09";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "4c61e7c67a78d0906ffa77794deeb45e53d659d2";
    hash = "sha256-3UHQJDi+9TW7yD2yWfD+1hr8iSvyd1HLGqbtk0iYlVg=";
  };

  vendorHash = "sha256-8Le/d6sXXH0dCORWLOFUjHlbGcKr0yqQ2l8GQzLaYt0=";

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
