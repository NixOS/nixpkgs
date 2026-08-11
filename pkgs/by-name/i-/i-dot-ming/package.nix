{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  installFonts,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "i.ming";
  version = "8.10";

  src = fetchFromGitHub {
    owner = "ichitenfont";
    repo = "I.Ming";
    tag = finalAttrs.version;
    hash = "sha256-TutIcX/DoeO5cwjD0o1IaXErStY73Cqk00NDKbXw39I=";
    rootDir = finalAttrs.version;
  };

  nativeBuildInputs = [ installFonts ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Open source Pan-CJK serif typeface";
    homepage = "https://github.com/ichitenfont/I.Ming";
    license = lib.licenses.ipa;
    platforms = lib.platforms.all;
    maintainers = [ lib.maintainers.linsui ];
  };
})
