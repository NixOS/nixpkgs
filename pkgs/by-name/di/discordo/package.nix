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
  version = "0-unstable-2025-07-28";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "a4c8787f1d1699ce661df9d6aaa5002568b6e75a";
    hash = "sha256-WN4qaL0kcvNcutoYHBvB9DP+/U4tDbUrkNW5FBPYpvQ=";
  };

  vendorHash = "sha256-0zPocgwSmHG0BEzitQoDLG8y8of3Bt9swfUSDzzedo8=";

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
