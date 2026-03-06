{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "hatsune-miku-cursors";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "supermariofps";
    repo = "hatsune-miku-windows-linux-cursors";
    tag = finalAttrs.version;
    hash = "sha256-OQjjOc9VnxJ7tWNmpHIMzNWX6WsavAOkgPwK1XAMwtE=";
  };

  installPhase = ''
    mkdir -p $out/share/icons
    mv ./miku-cursor-linux $out/share/icons/"Hatsune Miku Cursors"
  '';

  meta = {
    description = "Hatsune Miku Cursors for Linux";
    homepage = "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ bunbun ];
  };
})
