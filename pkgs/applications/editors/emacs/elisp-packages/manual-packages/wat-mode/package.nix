{
  lib,
  melpaBuild,
  fetchFromGitHub,
  unstableGitUpdater,
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

  ignoreCompilationError = false;

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    homepage = "https://github.com/devonsparks/wat-mode";
    description = "Emacs major mode for WebAssembly's text format";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nagy ];
  };
}
