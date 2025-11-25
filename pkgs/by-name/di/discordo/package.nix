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
  version = "0-unstable-2025-11-24";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "ac1436b4d4e132f92b48b3afdf3f430e2846b41a";
    hash = "sha256-qf7DPl/ZZlrjyX1dV9SP7wBiysqvZKNb+awYk6V+Lj8=";
  };

  vendorHash = "sha256-b5ilZPU6+KwiTj8aC0gqZvgGI+V69gF8LNxCpxwUy7c=";

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
