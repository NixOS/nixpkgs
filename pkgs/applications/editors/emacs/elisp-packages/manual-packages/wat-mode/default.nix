# Manually packaged until it is upstreamed to melpa
# See https://github.com/devonsparks/wat-mode/issues/1
{
  lib,
  melpaBuild,
  fetchFromGitHub,
}:

melpaBuild {
  pname = "wat-mode";
  version = "0-unstable-2022-07-13";

  src = fetchFromGitHub {
    owner = "devonsparks";
    repo = "wat-mode";
    rev = "46b4df83e92c585295d659d049560dbf190fe501";
    hash = "sha256-jV5V3TRY+D3cPSz3yFwVWn9yInhGOYIaUTPEhsOBxto=";
  };

  meta = {
    homepage = "https://github.com/devonsparks/wat-mode";
    description = "Emacs major mode for WebAssembly's text format";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nagy ];
  };
}
