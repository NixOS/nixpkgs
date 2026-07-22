{
  lib,
  anki-utils,
  fetchFromGitHub,
  fetchPnpmDeps,
  nodejs,
  pnpm_11,
  pnpmConfigHook,
  nix-update-script,
}:
let
  pnpm = pnpm_11;
in
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "jisho-kanji-stroke-order";
  version = "0-unstable-2026-07-29";
  src = fetchFromGitHub {
    owner = "soleuniverse101";
    repo = "anki-jisho-strokes";
    rev = "23b09d2e9b79e533f33915c8a7c37b492be9bbb8";
    hash = "sha256-LTQpVKzWEfZi4npD4Nj9by/SV5aiARBnXgONamTPriE=";
  };

  kanjivg = fetchFromGitHub {
    owner = "KanjiVG";
    repo = "kanjivg";
    rev = "bd13ffbcc9d85cb86ae98bbbf001d9069220b901";
    hash = "sha256-z1VvU/ZoDR3jEJiM1l8ZUujSs7uz6CqMCmTRyc+LGDM=";
  };

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-+T1jed5g8vWYLeAh+D8UHP1n6VN58BFeyJwySQvWpK8=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  buildPhase = ''
    runHook preBuild

    ln -s ${finalAttrs.kanjivg}/kanji resources/kanji

    pnpm process-svg

    runHook postBuild
  '';

  preInstall = ''
    cd addon
  '';

  meta = {
    description = "Display kanji's stroke order when hovering over it in the style of jisho.org";
    longDescription = ''
      This addon must be configured to apply to certain note types. The options to configure this add-on can be found [here](https://github.com/soleuniverse101/anki-jisho-strokes/blob/main/addon/config.md).
      Example:

      ```nix
      (pkgs.ankiAddons.jisho-kanji-stroke-order.withConfig {
        config = {
          note_types = [ "japanese anki deck" "*kanji*" ]
        };
      })
      ```
    '';
    homepage = "https://github.com/soleuniverse101/anki-jisho-strokes";
    license = lib.licenses.cc-by-sa-30;
    maintainers = with lib.maintainers; [ kentario ];
  };
})
