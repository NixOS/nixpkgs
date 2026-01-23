{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "puppy-reinforcement";
  version = "1.1.1";
  src = fetchFromGitHub {
    owner = "glutanimate";
    repo = "puppy-reinforcement";
    tag = "v${finalAttrs.version}";
    hash = "sha256-y52AjmYrFTcTwd4QAcJzK5R9wwxUSlvnN3C2O/r5cHk=";
  };
  sourceRoot = "${finalAttrs.src.name}/src/puppy_reinforcement";
  passthru.updateScript = nix-update-script { };
  meta = {
    description = "Encourage learners with pictures of cute puppies";
    longDescription = ''
      The options to configure this add-on can be found [here](https://github.com/glutanimate/puppy-reinforcement/blob/v${finalAttrs.version}/src/puppy_reinforcement/config.md).
      Extra images can also be added with `userFiles`.

      Example:

      ```nix
      pkgs.ankiAddons.puppy-reinforcement.withConfig {
        config = {
          encourage_every = 5;
        };
        userFiles = ./my-folder-of-the-most-cute-dogos;
      }
      ```
    '';
    homepage = "https://ankiweb.net/shared/info/1722658993";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ lomenzel ];
  };
})
