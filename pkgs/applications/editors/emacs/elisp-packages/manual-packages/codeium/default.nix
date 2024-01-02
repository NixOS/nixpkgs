{ trivialBuild, fetchFromGitHub, pkgs, lib, }:
trivialBuild {
  pname = "codeium";
  version = "1.6.13";
  src = fetchFromGitHub {
    owner = "Exafunction";
    repo = "codeium.el";
    rev = "1.6.13";
    hash = "sha256-CjT21GhryO8/iM0Uzm/s/I32WqVo4M3tSlHC06iEDXA=";
  };

  buildInputs = [ pkgs.codeium ];

  patches = [ ./codeium.el.patch ];
  postPatch = ''
    substituteInPlace codeium.el --subst-var-by codeium ${pkgs.codeium}/bin/codeium_language_server
  '';

  meta = {
    description = "Free, ultrafast Copilot alternative for Emacs";
    homepage = "https://github.com/Exafunction/codeium.el";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.running-grass ];
    platforms = pkgs.codeium.meta.platforms;
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };

}
