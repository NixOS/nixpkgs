{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2023-10-22";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "afaa155b510881efae8a9c27d3453cedc3fbb3b5";
    hash = "sha256-9Ls8IF6DoLUbUqdwqD5ncp9p/HUnAl8eaYYjnIAJcw0=";
  };

  vendorHash = "sha256-11dbOoajCXMonNy9bXy4RiT9FLH/Sga4+eH5mUFDlNA=";

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
