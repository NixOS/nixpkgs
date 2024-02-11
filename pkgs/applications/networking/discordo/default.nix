{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "unstable-2024-01-25";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "301b7c7a792b427595803679e37fe99007de9451";
    hash = "sha256-ufAlwlH++g9L3aaA5soJ6r2oiJZi8Ny/6P530oV+BiY=";
  };

  vendorHash = "sha256-fy3FI1K57hLAgbw3WfmVNZT9ywCSXwRKSq+ATjG+Qpo=";

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
