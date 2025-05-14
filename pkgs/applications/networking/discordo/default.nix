{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  makeWrapper,
  xsel,
  wl-clipboard,
}:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2025-05-11";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "232f4d469b67d746b9db067c0c73686dac87e938";
    hash = "sha256-k02oX7HAQ39UCm/hiS0cjibuZ/51sBTG1CnoP80e/mA=";
  };

  vendorHash = "sha256-gEwTpt/NPN1+YpTBmW8F34UotowrOcA0mfFgBdVFiTA=";

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s"
    "-w"
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

  meta = with lib; {
    description = "Lightweight, secure, and feature-rich Discord terminal client";
    homepage = "https://github.com/ayn2op/discordo";
    license = licenses.mit;
    maintainers = [ maintainers.arian-d ];
    mainProgram = "discordo";
  };
}
