# Manually packaged until it is upstreamed to melpa
# See https://github.com/devonsparks/wat-mode/issues/1
{ lib, trivialBuild, fetchFromGitHub, fetchpatch, emacs }:

trivialBuild rec {
  pname = "wat-mode";
  version = "unstable-2022-07-13";

  src = fetchFromGitHub {
    owner = "devonsparks";
    repo = pname;
    rev = "46b4df83e92c585295d659d049560dbf190fe501";
    hash = "sha256-jV5V3TRY+D3cPSz3yFwVWn9yInhGOYIaUTPEhsOBxto=";
  };

  meta = with lib; {
    homepage = "https://github.com/devonsparks/wat-mode";
    description = "An Emacs major mode for WebAssembly's text format";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nagy ];
    inherit (emacs.meta) platforms;
  };
}
