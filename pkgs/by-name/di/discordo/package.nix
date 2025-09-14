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
  version = "0-unstable-2025-08-06";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "cdd97ff900a099ca520e5a720c547780dd6de162";
    hash = "sha256-dJwinbkSVXxcNV9zXZaNnyZi1XorfNBITuYb9D987Vk=";
  };

  vendorHash = "sha256-6JpLXLoozkPWl7z0KGFIgr78bMR4DegvyEWODBKuWpE=";

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
