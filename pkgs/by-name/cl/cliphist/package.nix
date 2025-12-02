{
  lib,
  bash,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "cliphist";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "sentriz";
    repo = "cliphist";
    tag = "v${version}";
    hash = "sha256-y4FSl/Bj80XqCR0ZwjGEkqYUIF6zJHrYyy01XPFlzjU=";
  };

  vendorHash = "sha256-4XyDLOJHdre/1BpjgFt/W6gOlPOvKztE+MsbwE3JAaQ=";

  postInstall = ''
    cp ${src}/contrib/* $out/bin/
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  buildInputs = [ bash ];

  meta = with lib; {
    description = "Wayland clipboard manager";
    homepage = "https://github.com/sentriz/cliphist";
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "cliphist";
  };
}
