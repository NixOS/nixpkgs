{
  lib,
  buildGoModule,
  fetchFromGitHub,
  xorg,
}:

buildGoModule rec {
  pname = "storii";
  version = "0-unstable-2025-09-26";

  src = fetchFromGitHub {
    owner = "b2dennis";
    repo = "storii";
    rev = "da5d8ce2b12bd68a1b8a348202dc6f6b81f79c3c";
    hash = "sha256-7/bvthvx1BX+krcXv6x68DMdiraYr0R8h9D/eOZD4Ew=";
  };

  vendorHash = "sha256-lsRchL36mpOAY21qqTQ4+lhIpvoQq/jksBNWgqD5xo4=";

  subPackages = [ "cmd/storii-cli" ];

  buildInputs = [
    xorg.libX11
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    mv $out/bin/storii-cli $out/bin/storii
  '';

  meta = {
    description = "Secret manager written in golang";
    homepage = "https://github.com/b2dennis/storii";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ b2dennis ];
    mainProgram = "storii";
    platforms = lib.platforms.linux;
  };
}
