{
  lib,
  stdenv,
  fetchFromGitHub,
  openssl,
  libpcap,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "asleap";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "OscarAkaElvis";
    repo = "asleap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Xhj+yhmWX0blFkmVLVERYoz7SKCNrOrQoBmlXC0Vz24=";
  };

  buildInputs = [
    openssl
    libpcap
  ];

  env.PREFIX = placeholder "out";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/OscarAkaElvis/asleap/releases/tag/v${finalAttrs.version}";
    homepage = "https://github.com/OscarAkaElvis/asleap";
    description = "Cisco LEAP and Generic MS-CHAPv2 Dictionary Attack";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "asleap";
    platforms = lib.platforms.linux;
  };
})
