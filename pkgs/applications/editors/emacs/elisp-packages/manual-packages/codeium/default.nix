{
  lib,
  codeium,
  fetchFromGitHub,
  melpaBuild,
  replaceVars,
  gitUpdater,
}:

melpaBuild (finalAttrs: {
  pname = "codeium";
  version = "1.12.0";

  src = fetchFromGitHub {
    owner = "Exafunction";
    repo = "codeium.el";
    tag = finalAttrs.version;
    hash = "sha256-NnCpoGMJKBsPa7KtavEg/4+tdqbrCCemvYYT1p6BcdY=";
  };

  patches = [
    (replaceVars ./0000-set-codeium-command-executable.patch {
      codeium = lib.getExe codeium;
    })
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Free, ultrafast Copilot alternative for Emacs";
    homepage = "https://github.com/Exafunction/codeium.el";
    license = lib.licenses.mit;
    maintainers = [ ];
    inherit (codeium.meta) platforms;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
