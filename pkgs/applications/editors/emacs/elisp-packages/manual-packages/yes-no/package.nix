{
  lib,
  fetchurl,
  melpaBuild,
}:

melpaBuild {
  pname = "yes-no";
  version = "0-unstable-2017-10-01";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/emacsmirror/emacswiki.org/143bcaeb679a8fa8a548e92a5a9d5c2baff50d9c/yes-no.el";
    hash = "sha256-ceCOBFfixmGVB3kaSvOv1YZThC2pleYnS8gXhLrjhA8=";
  };

  ignoreCompilationError = false;

  meta = {
    homepage = "https://www.emacswiki.org/emacs/yes-no.el";
    description = "Specify use of `y-or-n-p' or `yes-or-no-p' on a case-by-case basis";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ jcs090218 ];
  };
}
