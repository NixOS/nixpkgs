{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "host-spawn";
  version = "1.6.2";

  src = fetchFromGitHub {
    owner = "1player";
    repo = "host-spawn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bCEyoHsISZ2K7fOsOOAhZRv/a6RptVDlwSspomacb/0=";
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
})
