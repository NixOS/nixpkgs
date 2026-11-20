{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  yarnConfigHook,
  npmHooks,
  nodejs-slim,
  fetchYarnDeps,
  flavour ? [ "mocha" ],
  accents ? [ "blue" ],
}:
let
  validFlavours = [
    "mocha"
    "macchiato"
    "frappe"
    "latte"
  ];
  validAccents = [
    "rosewater"
    "flamingo"
    "pink"
    "mauve"
    "red"
    "maroon"
    "peach"
    "yellow"
    "green"
    "teal"
    "sky"
    "sapphire"
    "blue"
    "lavender"
  ];
in
lib.checkListOfEnum "Invalid accent, valid accents are ${toString validAccents}" validAccents
  accents
  lib.checkListOfEnum
  "Invalid flavour, valid flavours are ${toString validFlavours}"
  validFlavours
  flavour
  stdenvNoCC.mkDerivation
  (finalAttrs: {
    pname = "catppuccin-discord";
    version = "0-unstable-2024-12-08";

    src = fetchFromGitHub {
      owner = "catppuccin";
      repo = "discord";
      rev = "16b1e5156583ee376ded4fa602842fa540826bbc";
      hash = "sha256-ECVHRuHbe3dvwrOsi6JAllJ37xb18HaUPxXoysyPP70=";
    };

    nativeBuildInputs = [
      yarnConfigHook
      npmHooks.npmInstallHook
      nodejs-slim
    ];

    yarnOfflineCache = fetchYarnDeps {
      yarnLock = "${finalAttrs.src}/yarn.lock";
      hash = "sha256-2N4UI6Ap+zk7jtDCAsjGtwfDSiyOtB9YDOXUxYRCw60=";
    };

    buildPhase = ''
      runHook preBuild

      export HOME=$(mktemp -d)
      yarn --offline release

      runHook postBuild
    '';

    # "true" disables the dist phase, as there are no binaries and installation of themes
    # will be handled in installPhase below.
    distPhase = "true";

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share

      for FLAVOUR in ${toString flavour}; do
        for ACCENT in ${toString accents}; do
          cp -va dist/dist/catppuccin-"$FLAVOUR"-"$ACCENT".theme.css $out/share
        done;
      done;

      runHook postInstall
    '';

    meta = {
      description = "Soothing pastel theme for Discord";
      homepage = "https://github.com/catppuccin/discord";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ NotAShelf ];
      platforms = lib.platforms.all;
      sourceProvenance = with lib.sourceTypes; [ fromSource ];
    };
  })
