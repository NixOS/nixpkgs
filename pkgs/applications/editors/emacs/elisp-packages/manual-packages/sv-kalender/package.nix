{
  lib,
  fetchurl,
  melpaBuild,
}:

melpaBuild {
  pname = "sv-kalender";
  version = "1.11";

  src = fetchurl {
    url = "https://raw.githubusercontent.com/emacsmirror/emacswiki.org/ec4fa36bdba5d2c5c4f5e0400a70768c10e969e8/sv-kalender.el";
    hash = "sha256-VXz3pO6N94XM8FzLSAoYrj3NEh4wp0UiuG6ad8M7nVU=";
  };

  ignoreCompilationError = false;

  meta = {
    homepage = "https://www.emacswiki.org/emacs/sv-kalender.el";
    description = "Swedish calendar for Emacs";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.rycee ];
  };
}
