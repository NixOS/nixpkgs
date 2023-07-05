{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2023-04-07";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "f8c58057945b1ded2f78dc0956ea25aa281a0b31";
    hash = "sha256-FUSPQK4rB0J89s+I7yhF8SQ/Q9uygQSCF9o6ltYxOk4=";
  };

  vendorHash = "sha256-fLhyyIChqh+eEzht3CSLPfx6glw0YhiTb9PsbWJafWQ=";

  CGO_ENABLED = 0;

  ldflags = [ "-s" "-w" ];

  # Clipboard support on X11 and Wayland
  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    wrapProgram $out/bin/discordo \
      --prefix PATH : ${lib.makeBinPath [ xsel wl-clipboard ]}
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = with lib; {
    description = "A lightweight, secure, and feature-rich Discord terminal client";
    homepage = "https://github.com/ayn2op/discordo";
    license = licenses.mit;
    maintainers = [ maintainers.arian-d ];
  };
}
