{
  lib,
  codeium,
  fetchFromGitHub,
  melpaBuild,
  substituteAll,
  gitUpdater,
}:

melpaBuild {
  pname = "codeium";
  version = "1.6.13";

  src = fetchFromGitHub {
    owner = "Exafunction";
    repo = "codeium.el";
    rev = "1.6.13";
    hash = "sha256-CjT21GhryO8/iM0Uzm/s/I32WqVo4M3tSlHC06iEDXA=";
  };

  patches = [
    (substituteAll {
      src = ./0000-set-codeium-command-executable.patch;
      codeium = lib.getExe' codeium "codeium_language_server";
    })
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Free, ultrafast Copilot alternative for Emacs";
    homepage = "https://github.com/Exafunction/codeium.el";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.running-grass ];
    inherit (codeium.meta) platforms;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };

}
