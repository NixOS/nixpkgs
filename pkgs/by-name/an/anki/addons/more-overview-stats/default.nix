{
  lib,
  anki-utils,
  fetchFromGitHub,
  unstableGitUpdater,
}:
anki-utils.buildAnkiAddon (finalAttrs: {
  pname = "more-overview-stats";
  version = "2.1-unstable-2025-02-17";
  src = fetchFromGitHub {
    owner = "patrick-mahnkopf";
    repo = "Anki_More_Overview_Stats";
    rev = "239dccd68e2cc9e845b78947f6426b47a05582ea";
    hash = "sha256-I5FjE7h2CaHzUuPFSK8DA91CJB+ngBs8ZF1UJo9gdNM=";
  };
  passthru.updateScript = unstableGitUpdater { };
  meta = {
    description = "Extending Anki's default overview screen with more statistics";
    homepage = "https://github.com/patrick-mahnkopf/Anki_More_Overview_Stats";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
  };
})
