{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hatsune-miku-windows-linux-cursors";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "supermariofps";
    repo = "hatsune-miku-windows-linux-cursors";
    rev = "471ff88156e9a3dc8542d23e8cae4e1c9de6e732";
    hash = "sha256-HCHo4GwWLvjjnKWNiHb156Z+NQqliqLX1T1qNxMEMfE=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons
    cp -r $src/miku-cursor-linux $out/share/icons/
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Hatsune Miku cursor theme";
    homepage = "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors";
    license = lib.licenses.unfreeRedistributable;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.undefinedprophet ];
  };
})
