{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "micromdm";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "micromdm";
    repo = "micromdm";
    rev = "v${version}";
    hash = "sha256-b0ST2krDY4avvcdcpUInTH1On0cGKTsdwPpL9HbSPig=";
  };

  vendorHash = "sha256-NxjxHKEB1+d2BsVImL405anuMcKF+DlpnRPvKkGNMAQ=";

  meta = {
    description = "Mobile Device Management server for Apple Devices, focused on giving you all the power through an API";
    homepage = "https://github.com/micromdm/micromdm";
    license = lib.licenses.mit;
    mainProgram = "micromdm";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ neverbehave ];
  };
}
