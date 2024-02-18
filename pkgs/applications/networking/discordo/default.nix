{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2024-02-16";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "7476d8b391f23fa576f8f34eef3829c6212c6331";
    hash = "sha256-x1/CXHqfiT0HgIPsiRluifPOJUrulN+fih0aOrj3us0=";
  };

  vendorHash = "sha256-PW0PPMlNB5aa81tsYWUk9mWfSyafI5A0OxqJTCe0OdI=";

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
    mainProgram = "discordo";
  };
}
