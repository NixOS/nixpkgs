{
  lib,
  melpaBuild,
  fetchFromSourcehut,
  unstableGitUpdater,
}:

melpaBuild {
  pname = "org-publish-rss";
  version = "0-unstable-2026-01-09";

  src = fetchFromSourcehut {
    vc = "git";
    owner = "~taingram";
    repo = "org-publish-rss";
    rev = "92aa98cb41635f7dd577295223a64ae44b80c99d";
    hash = "sha256-OPAyTLcYSKYqCcO6DP0yfoNYsIZzOwhZ0u9YcE4+TFU=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Automatically generate RSS feeds for org-publish projects";
    homepage = "https://git.sr.ht/~taingram/org-publish-rss";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ tetov ];
  };
}
