{
  lib,
  melpaBuild,
  fetchurl,
}:

melpaBuild {
  pname = "prolog-mode";
  ename = "prolog";
  version = "1.28";

  src = fetchurl {
    url = "https://bruda.ca/_media/emacs/prolog.el";
    hash = "sha256-ZzIDFQWPq1vI9z3btgsHgn0axN6uRQn9Tt8TnqGybOk=";
  };

  postPatch = ''
    substituteInPlace prolog.el \
      --replace-fail ";; prolog.el ---" ";;; prolog.el ---"
  '';

  meta = {
    homepage = "https://bruda.ca/emacs/prolog_mode_for_emacs/";
    description = "Prolog mode for Emacs";
    license = lib.licenses.gpl2Plus;
  };
}
