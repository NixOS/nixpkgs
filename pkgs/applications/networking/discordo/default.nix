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
  version = "0-unstable-2025-07-13";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "0b40c3d98e3a0eadd6acc4f87f0b4696b928ab16";
    hash = "sha256-/mOFcBur3Tv6gwbbA7xaULbDQz0YEn/31PYaFj5nYos=";
  };

  vendorHash = "sha256-Br0fF3HG9tFbuVtzO1DCKlC5SpN9TCP4NG8BksMeifk=";

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
