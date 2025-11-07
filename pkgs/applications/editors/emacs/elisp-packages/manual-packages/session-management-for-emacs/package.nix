{
  melpaBuild,
  fetchzip,
  lib,
}:

melpaBuild rec {
  pname = "session-management-for-emacs";
  ename = "session";
  version = "2.2a";
  melpaVersion = "2.2"; # default value derived from version is not valid for Emacs

  src = fetchzip {
    url = "mirror://sourceforge/emacs-session/session-${version}.tar.gz";
    hash = "sha256-lc6NIX+lx97qCs5JqG7x0iVE6ki09Gy7DEQuPW2c+7s=";
  };

  # https://github.com/NixOS/nixpkgs/issues/335421
  ignoreCompilationError = true;

  meta = {
    /*
      installation: add to your ~/.emacs
      (require 'session)
      (add-hook 'after-init-hook 'session-initialize)
    */
    description = "Small session management for emacs";
    homepage = "https://emacs-session.sourceforge.net/";
    license = lib.licenses.gpl2;
  };
}
