# To automatically load darcsum when needed, add the following to your emacs init file:
#
#   (autoload 'darcsum-changes "darcsum" nil t)
#   (autoload 'darcsum-whatsnew "darcsum" nil t)
#   (autoload 'darcsum-view "darcsum" nil t)
#
# (These lines were copied from 50darcsum.el in the darcsum repository.)


{ fetchdarcs, stdenv }:

stdenv.mkDerivation {
  name = "darcsum-1.3";

  src = fetchdarcs {
    url = http://hub.darcs.net/simon/darcsum;
    context = ./darcs_context;
    sha256 = "18dyk2apmnjapd604a5njfqwjri1mc7lgjaajy9phicpibgdrwzh";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    install -d "$out/share/emacs/site-lisp"
    install darcsum.el "$out/share/emacs/site-lisp"
  '';

  meta = {
    description = "A pcl-cvs like interface for managing darcs patches.";
    homepage = "http://hub.darcs.net/simon/darcsum";
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.falsifian ];
  };
}
