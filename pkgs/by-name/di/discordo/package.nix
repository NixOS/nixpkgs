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
  version = "0-unstable-2025-10-16";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "9a1bdac4fbb715374acc88f59e2ca614b72a5b2c";
    hash = "sha256-pCY82Xzlq+QVOpr3aTthfcPXjTjuKfO63oqDD7Hl/sc=";
  };

  vendorHash = "sha256-lYlVr9sKceCaOFpv7owCeaP9PyZWh/U9lUrGjUh98hk=";

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
