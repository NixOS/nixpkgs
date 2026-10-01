{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  nix-update-script,
  plemoljp-hs,
  plemoljp-nf,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "plemoljp";
  version = "3.1.0";

  src = fetchzip {
    url = "https://github.com/yuru7/PlemolJP/releases/download/v${finalAttrs.version}/PlemolJP_v${finalAttrs.version}.zip";
    hash = "sha256-X4DUAU7uicWtm8o3L9HmfU9By1YMnnjVrVU0iyw273A=";
  };

  nativeBuildInputs = [ installFonts ];

  passthru = {
    inherit plemoljp-hs plemoljp-nf;

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex=^v([0-9.]+)$"
        "--subpackage"
        "plemoljp-hs"
        "--subpackage"
        "plemoljp-nf"
      ];
    };
  };

  meta = {
    description = "Composite font of IBM Plex Mono and IBM Plex Sans JP";
    homepage = "https://github.com/yuru7/PlemolJP";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ kachick ];
  };
})
