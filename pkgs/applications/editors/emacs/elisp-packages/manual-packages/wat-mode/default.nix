# Manually packaged until it is upstreamed to melpa
# See https://github.com/devonsparks/wat-mode/issues/1
{ lib, melpaBuild, fetchFromGitHub, writeText }:

melpaBuild rec {
  pname = "wat-mode";
  version = "20220713.1";

  src = fetchFromGitHub {
    owner = "devonsparks";
    repo = pname;
    rev = "46b4df83e92c585295d659d049560dbf190fe501";
    hash = "sha256-jV5V3TRY+D3cPSz3yFwVWn9yInhGOYIaUTPEhsOBxto=";
  };

  commit = "46b4df83e92c585295d659d049560dbf190fe501";

  recipe = writeText "recipe" ''
    (wat-mode :repo "devonsparks/wat-mode" :fetcher github)
  '';

  meta = {
    homepage = "https://github.com/devonsparks/wat-mode";
    description = "Emacs major mode for WebAssembly's text format";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nagy ];
  };
}
