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
  version = "0-unstable-2026-02-26";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "27dd6e09c8cde848261248a505a4efbabdcc9e09";
    hash = "sha256-3rr7mbbPw5jrON7J80TaCZ7lBALKdtZ6vI2+uGJJaoI=";
  };

  vendorHash = "sha256-yzGKRrPPBjg/e9zkimCb99emLHBWM10FJvlL23HbTRU=";

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
