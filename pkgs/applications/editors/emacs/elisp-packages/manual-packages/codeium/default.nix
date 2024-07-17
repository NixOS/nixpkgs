{
  fetchFromGitHub,
  melpaBuild,
  pkgs,
  lib,
  substituteAll,
  writeText,
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
  commit = "02f9382c925633a19dc928e99b868fd5f6947e58";
  buildInputs = [ pkgs.codeium ];

  recipe = writeText "recipe" ''
    (codeium
      :repo "Exafunction/codeium.el"
      :fetcher github)
  '';

  patches = [
    (substituteAll {
      src = ./codeium.el.patch;
      codeium = "${pkgs.codeium}/bin/codeium_language_server";
    })
  ];

  meta = {
    description = "Free, ultrafast Copilot alternative for Emacs";
    homepage = "https://github.com/Exafunction/codeium.el";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.running-grass ];
    platforms = pkgs.codeium.meta.platforms;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };

}
