{ stdenv, fetchgit, emacs }:

stdenv.mkDerivation rec {
  rev = "646482203aacdf847d57d0a96263fddcfc33fb61";
  name = "emacs-offlineimap-${rev}";

  src = fetchgit {
    inherit rev;
    url = "git://git.naquadah.org/offlineimap-el.git";
    sha256 = "0az4llfgva4wvpljyc5s2m7ggfnj06ssp32x8bncr5fzksha3r7b";
  };

  buildInputs = [ emacs ];

  installPhase = ''
    substituteInPlace offlineimap.el --replace "Machine.MachineUI" "machineui"
    emacs --batch -f batch-byte-compile offlineimap.el
    install -d $out/share/emacs/site-lisp
    install offlineimap.el offlineimap.elc $out/share/emacs/site-lisp
  '';

  meta = {
    description = "OfflineIMAP support for Emacs";
    homepage = "http://julien.danjou.info/projects/emacs-packages#offlineimap";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}
