{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-vortex-ubuntu-theme";
  version = "0-unstable-2024-05-05";

  src = fetchFromGitHub {
    owner = "emanuele-scarsella";
    repo = "vortex-ubuntu-plymouth-theme";
    rev = "331a201918a3b026dd200659403c1cf779c718f0";
    hash = "sha256-RSWfuKCdsuFA2e5kb0OXnxW+QV7b2iHVvZEKVHoLgMw=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/vortex-ubuntu
    cp vortex-ubuntu/* $out/share/plymouth/themes/vortex-ubuntu
    substituteInPlace $out/share/plymouth/themes/vortex-ubuntu/vortex-ubuntu.plymouth \
      --replace-fail "/usr/" "$out/"
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Animated Plymouth boot theme with rotating Ubuntu logo";
    longDescription = ''
      Animated Plymouth theme with the Ubuntu logo and a futuristic and elegant look.
      Disk encryption password prompt is supported.
    '';
    homepage = "https://github.com/emanuele-scarsella/vortex-ubuntu-plymouth-theme";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ johnrtitor ];
  };
}
