{
  lib,
  stdenvNoCC,
  fetchzip,
  installFonts,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "arris";
  version = "2.002";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/huntrontrakkr/arris-type/releases/download/v${finalAttrs.version}/Arris-${finalAttrs.version}.zip";
    hash = "sha256-cbUHRvHFdLcyrWirPvb6aIU1IJASrkTSA61CKXk94z8=";
  };

  nativeBuildInputs = [ installFonts ];

  outputs = [
    "out"
    "webfont"
  ];

  postInstall = ''
    install -Dm644 OFL.txt "$out/share/licenses/arris/OFL.txt"
    install -Dm644 OFL.txt "$webfont/share/licenses/arris/OFL.txt"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Typeface based on Dymaxion's Chamfer clock figures";
    homepage = "https://github.com/huntrontrakkr/arris-type";
    license = lib.licenses.ofl;
    maintainers = with lib.maintainers; [ levilovie ];
    platforms = lib.platforms.all;
  };
})
