{ lib, buildGoModule, fetchFromGitHub, nix-update-script, makeWrapper, xsel
, wl-clipboard }:

buildGoModule rec {
  pname = "discordo";
  version = "0-unstable-2025-01-27";

  src = fetchFromGitHub {
    owner = "ayn2op";
    repo = pname;
    rev = "1783361d5fb839e54f4562a9c42eb478d9cc8f57";
    hash = "sha256-AU7gT+q1vF4WWn5o2OCiAjHjub0ig1O7/CjFnuQaN6I=";
  };

  vendorHash = "sha256-FsZRh4k9ucmAruJa1MZ4kVVryrEuHy9StgXHvgBiWSg=";

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
