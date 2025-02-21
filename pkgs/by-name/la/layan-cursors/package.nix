{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "layan-cursors";
  version = "2021-08-01";

  src = fetchFromGitHub {
    owner = "vinceliuice";
    repo = "Layan-cursors";
    tag = "${finalAttrs.version}";
    hash = "sha256-Izc5Q3IuM0ryTIdL+GjhRT7JKbznyxS2Fc4pY5dksq4=";
  };

  installPhase = ''
    runHook preInstall

    install -dm 0755 $out/share/icons
    cp -R dist $out/share/icons/layan-cursors

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "cursor theme inspired by layan gtk theme and based on capitaine-cursors";
    downloadPage = "https://github.com/vinceliuice/Layan-cursors/releases";
    homepage = "https://github.com/vinceliuice/Layan-cursors/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ idlip ];
  };

})
