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
  version = "0-unstable-2026-04-09";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "d804e0271c51239e18109dd786be73347cf21dfd";
    hash = "sha256-dgj3JWJ3NGwBvvHV/phfjIHa612XNUfYArXXpzJ0Mf4=";
  };

  vendorHash = "sha256-BSYPEUE6qyNY4+ur+uVB66ogYVktm9AUCzLTMiJMmKQ=";

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
