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
  version = "0-unstable-2025-12-06";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "a9359209369cf816bdab76d4feeb8270a5410040";
    hash = "sha256-Dudlghaz3RGZaHSExyzmeVUZufU8w1ONSE3nh/GINHQ=";
  };

  vendorHash = "sha256-IFZcBq58qLRmU0eDrPNh/vEL3L+FZX1AHS09vtWmRaQ=";

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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ arian-d ];
    mainProgram = "discordo";
  };
})
