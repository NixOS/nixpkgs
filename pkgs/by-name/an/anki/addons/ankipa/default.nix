{
  lib,
  anki-utils,
  fetchFromGitHub,
  nix-update-script,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "ankipa";
  version = "0-unstable-2025-12-14";
  src = fetchFromGitHub {
    owner = "warleysr";
    repo = "ankipa";
    rev = "ad2bc714715f98b392e642cac42af5e0b83959d3";
    hash = "sha256-fLIqLlJtX7e3Yx1gZizjAOteaIPnlthfrCjv8qn7jy8=";
  };
  patches = [ ./remove-new-languages-check.patch ];
  passthru.updateScript = nix-update-script { };
  meta = {
    description = ''
      Lets you record your own pronounciation of a word or phrase and get it rated by Azure Pronounciation Assessment.
    '';
    homepage = "https://github.com/warleysr/ankipa";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ r3lphi ];
  };
})
