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
  version = "0-unstable-2026-01-23";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "08bda9e40541d32e9313405824550cff41f60912";
    hash = "sha256-80ZG1lQV4/kf4zqW2ANkRIJSZbjwCKsV0TTwSZuoMGk=";
  };

  vendorHash = "sha256-quRRGf9eVCK7OYgPhBn+qM6WTUGra9I2eUxkRbCXxB8=";

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
    maintainers = with lib.maintainers; [ arian-d ];
    mainProgram = "discordo";
  };
})
