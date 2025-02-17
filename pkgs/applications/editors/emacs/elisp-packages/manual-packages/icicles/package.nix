{
  lib,
  fetchFromGitHub,
  melpaBuild,
}:

melpaBuild {
  pname = "icicles";
  version = "0-unstable-2024-10-29";

  src = fetchFromGitHub {
    owner = "emacsmirror";
    repo = "icicles";
    rev = "1c817db03aa32ef92d99661abc5e83da3188ab56";
    hash = "sha256-pH4FQuAnYf8eNiwiLl+OOOxzdecrncay6TcHjNG16sk=";
  };

  meta = {
    homepage = "https://emacswiki.org/emacs/Icicles";
    description = "Emacs library that enhances minibuffer completion";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
  };
}
