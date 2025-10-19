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
  version = "0-unstable-2025-10-12";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = "discordo";
    rev = "eeeeb75c66ceeb4dfc2eef69f006a2665e1d66d8";
    hash = "sha256-pct+C77K7ZBc4grfvJfDBoGaFed3UIrJRXXLlv6wUis=";
  };

  vendorHash = "sha256-+BBjVyyGR52ssp3pvODFOUmOcLa9PBXDhFlS9lsZF08=";

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
