{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  xsel,
  wl-clipboard,
}:

buildGoModule (finalAttrs: {
  pname = "discordo";
  version = "0-unstable-2025-09-30";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "6f670612e889dfcd7991d570b154d1039b1afc10";
    hash = "sha256-0YdOKXiI/popKhMJgQXJCHIiCEST4aPcLXCQxx6WzzA=";
  };

  vendorHash = "sha256-9u861o/pF272PzspTdLkrXdCf/AquG2GmGQ4Nuvx7GE=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
  ];

  # Clipboard support on X11 and Wayland
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    makeWrapper
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
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
