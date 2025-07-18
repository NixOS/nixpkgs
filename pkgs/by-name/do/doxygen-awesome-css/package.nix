{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "doxygen-awesome-css";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "jothepro";
    repo = "doxygen-awesome-css";
    rev = "v${finalAttrs.version}";
    hash = "sha256-g4Smy7BJ//4wQigAnx5fJQe5QxoLc6Aopm8O7S2lVkY=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/jothepro/doxygen-awesome-css/releases/tag/v${finalAttrs.version}";
    description = "CSS theme for doxygen html-documentation with lots of customization parameters";
    homepage = "https://github.com/jothepro/doxygen-awesome-css";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
