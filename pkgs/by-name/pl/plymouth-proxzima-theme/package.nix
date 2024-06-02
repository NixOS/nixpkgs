{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "plymouth-proxzima-theme";
  version = "0-unstable-2023-01-30";

  src = fetchFromGitHub {
    owner = "PROxZIMA";
    repo = "proxzima-plymouth";
    rev = "b6e335a631e057942700de5c523198a5b8061d9c";
    hash = "sha256-f4CtXKsZPc/gZMVD+MJrHMrMw7TTFUndhUT4YLpfORU=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/plymouth/themes/proxzima
    cp proxzima/* $out/share/plymouth/themes/proxzima
    substituteInPlace $out/share/plymouth/themes/proxzima/proxzima.plymouth \
      --replace-fail "/usr/" "$out/"
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "A techno Plymouth theme with crazy animation";
    homepage = "https://github.com/PROxZIMA/proxzima-plymouth";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ johnrtitor ];
  };
}
