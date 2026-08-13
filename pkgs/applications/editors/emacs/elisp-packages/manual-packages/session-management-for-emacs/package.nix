{
  melpaBuild,
  fetchzip,
  lib,
}:

melpaBuild (finalAttrs: {
  pname = "session-management-for-emacs";
  ename = "session";
  version = "2.4b";
  melpaVersion = "2.4"; # default value derived from version is not valid for Emacs

  src = fetchzip {
    url = "mirror://sourceforge/emacs-session/session-${finalAttrs.version}.tar.gz";
    hash = "sha256-xF/hyUyerZPXgklOn2DElJtbyPZqSG/6S2PPxh971F0=";
  };

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
})
