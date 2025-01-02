{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2024-12-22";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "9f15a6342413f68531402b8aeb5ed272159fc370";
    hash = "sha256-8VBw7DsX/xnNkfiIe8jiG2oXjIp1tNT6wy6eTDBZxUg=";
  };

  vendorHash = "sha256-UTZIx4zXIMdQBQXfzk3+j43yx7vlitw4Mwmon8oYjd8=";

  env.CGO_ENABLED = 0;

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
    description = "Lightweight, secure, and feature-rich Discord terminal client";
    homepage = "https://github.com/ayn2op/discordo";
    license = licenses.mit;
    maintainers = [ maintainers.arian-d ];
    mainProgram = "discordo";
  };
}
