{ fetchFromGitHub, fetchgit, git, stdenv, emacs, w3m, imagemagick, texinfo, autoreconfHook }:

let date = "2019-02-20"; in
stdenv.mkDerivation rec {
  name = "emacs-w3m-${date}";

  # w3mhack.el expects the build dir to be a git clone repo. It
  # looks into .git with the git executable and only does so if
  # .git/config is present. Otherwise the build fails.

  src = fetchgit {
    url = "http://github.com/emacs-w3m/emacs-w3m";
    rev = "7fa00f90b3bff8562768d0a15b32012cededcb47";
    sha256 = "15q40aqfda40slkgs0fg0svm0x47a98nz81ysxb5nh0kr45ha67i";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ autoreconfHook git ];
  buildInputs = [ emacs w3m texinfo ];

  # XXX: Should we do the same for xpdf/evince, gv, gs, etc.?
  patchPhase = ''
    sed -i "w3m.el" \
        -e 's|defcustom w3m-command nil|defcustom w3m-command "${w3m}/bin/w3m"|g ;
            s|(w3m-which-command "display")|"${imagemagick.out}/bin/display"|g'

    sed -i "w3m-image.el" \
        -e 's|(w3m-which-command "convert")|"${imagemagick.out}/bin/convert"|g ;
            s|(w3m-which-command "identify")|"${imagemagick.out}/bin/identify"|g'
  '';

  configureFlags = [
    "--with-lispdir=$(out)/share/emacs/site-lisp/emacs-w3m"
    "--with-icondir=$(out)/share/emacs/site-lisp/emacs-w3m/images"
  ];

  postConfigure = ''
     # w3mhack.el refuses to work if .git/config is not found.
     touch .git/config
  '';
  meta = {
    description = "Emacs-w3m, a simple Emacs interface to the w3m web browser";

    longDescription = ''
      Emacs/W3 used to be known as the most popular WEB browser on Emacs, but
      it worked so slowly that we wanted a simple and speedy alternative.

      w3m is a pager with WWW capability, developed by Akinori ITO. Although
      it is a pager, it can be used as a text-mode WWW browser. Then we
      developed a simple Emacs interface to w3m.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    homepage = https://github.com/emacs-w3m/emacs-w3m;

    maintainers = [ ];
  };
}
