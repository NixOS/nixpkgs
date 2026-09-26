{
  lib,
  anki-utils,
  fetchFromGitHub,
  python3,
}:
let
  pythonEnv = python3.withPackages (
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

  postInstall = ''
    ln -s ${pythonEnv}/${python3.sitePackages} "$out/$installPrefix/dist"
  '';

  patches = [ ./0001-Default-snapshot_path-to-XDG_DATA_HOME-crowdanki.patch ];

  meta = {
    description = "Plugin for Anki SRS designed to facilitate cooperation on creation of notes and decks.";
    homepage = "https://github.com/stvad/crowdanki";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ marcg03 ];
  };
})
