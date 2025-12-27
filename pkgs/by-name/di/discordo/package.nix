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
  version = "0-unstable-2025-12-26";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "4ee0320a95267c81676340b7837bad6e9669a087";
    hash = "sha256-HzN3BAxEsXiJUDPsSUnAVhhmP9vck25zC2+FA1iDsAI=";
  };

  vendorHash = "sha256-4OABxwKhwK6jV2H9xP4oCH4sESPUNVDN7M3jnDOStpI=";

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
