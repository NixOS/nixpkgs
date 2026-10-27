{
  lib,
  anki,
  anki-utils,
  fetchFromGitHub,
}:
let
  pythonEnv = anki.python.withPackages (
    ps: with ps; [
      cached-property
      dulwich
      pyfunctional
      pygtrie
      pyyaml
    ]
  );
in
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "crowdanki";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner = "stvad";
    repo = "crowdanki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j6yucnZF/Q04+KFGX3+FGs9DojAx0Xc50055f/eprqU=";
  };

  sourceRoot = "${finalAttrs.src.name}/crowd_anki";

  preInstall = "ln -s ${pythonEnv}/${anki.python.sitePackages} dist";

  meta = {
    description = "Facilitate cooperation on creation of Anki notes and decks";
    longDescription = ''
      This add-on must have its snapshot_path configured.

      Example:

      ```nix
      pkgs.ankiAddons.crowdanki.withConfig {
        config = {
          snapshot_path = "/home/user/.local/share/crowdanki";
        };
      }
      ```
    '';
    homepage = "https://github.com/stvad/crowdanki";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcg03 ];
  };
})
