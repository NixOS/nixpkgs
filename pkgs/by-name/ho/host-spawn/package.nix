{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "host-spawn";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "1player";
    repo = "host-spawn";
    rev = "v${version}";
    hash = "sha256-V8WI0TyJw+dkCyG8huIrg6VDFI2Kmak7bI/GXU8RI/w=";
  };

  vendorHash = "sha256-Agc3hl+VDTNW7cnh/0g4G8BgzNAX11hKASYQKieBN4M=";

  meta = {
    homepage = "https://github.com/1player/host-spawn";
    description = "Run commands on your host machine from inside your flatpak sandbox, toolbox or distrobox containers";
    license = lib.licenses.mit0;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ garrison ];
    mainProgram = "host-spawn";
  };
}
