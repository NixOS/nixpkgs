{ fetchurl, stdenv, curl, openssl, zlib, expat, perl, gettext, cpio
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_45
, libxslt, tcl, tk, makeWrapper
, svnSupport, subversion, perlLibs
, guiSupport
, sourceFromHead
, autoconf
}:

# `git-svn' support requires Subversion and various Perl libraries.
# FIXME: We should make sure Subversion comes with its Perl bindings.
assert svnSupport -> (subversion != null && perlLibs != [] && subversion.perlBindings);

assert svnSupport -> subversion.perlBindings;

stdenv.mkDerivation rec {
  # the glob patch adds the filter [touching paths (glob)] to gitk
  # contact marco-oweber@gmx.de if you want to know more details
  name = "git-git-with-glob-patch";

  # REGION AUTO UPDATE:     { name="git"; type="git"; url="git://git.kernel.org/pub/scm/git/git.git"; }
  src = sourceFromHead "git-8b43d378dff4d490165dbac05a0bf5da2011bfa5.tar.gz"
               (fetchurl { url = "http://mawercer.de/~nix/repos/git-8b43d378dff4d490165dbac05a0bf5da2011bfa5.tar.gz"; sha256 = "a910bbac05c6e349a0bcfd9a27f7045916e5d07dc4acb4baf6d92475c30e28dc"; });
  # END

  patchePhase = ''
    patch -p1 < ${./docbook2texi-2.patch}
    sed -i 's/docbook2x-texi/docbook2texi/gc' Documentation/Makefile
  '';
  # maybe this introduces unneccessary dependencies ?
  patchPhase = "
    unset patchPhase; patchPhase;
    sed -i 's=/usr/bin/perl=$perl/bin/perl=g' `find -type f`
    sed -i 's=/bin/pwd=pwd=g' `find -type f`
  ";

  inherit perl;
  buildInputs = [curl openssl zlib expat gettext cpio makeWrapper autoconf]
    ++ # documentation tools
       [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_45 libxslt ]
    ++ stdenv.lib.optionals guiSupport [tcl tk];

  preConfigure = "autoconf";
  makeFlags = "install install-doc prefix=\${out} PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell}";

  postInstall =
    ''
      # Install Emacs mode.
      echo "installing Emacs mode..."
      ensureDir $out/share/emacs/site-lisp
      cp -p contrib/emacs/*.el $out/share/emacs/site-lisp

      wrapArgs=
    '' # */

   + (if svnSupport then

      ''# wrap git-svn
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString perlLibs}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
#cp git-svn "$out/bin"
        wrapArgs="$wrapArgs --set GITPERLLIB $gitperllib"
        wrapArgs="$wrapArgs --prefix PATH : ${subversion}/bin"
       '' else "")

   + ''# Install man pages and Info manual
       make PERL_PATH="${perl}/bin/perl" cmd-list.made install install-info \
         -C Documentation ''

   + (if guiSupport then ''
       # Wrap Tcl/Tk programs
         wrapArgs="$wrapArgs --set TK_LIBRARY ${tk}/lib/tk8.4"
         wrapArgs="$wrapArgs --prefix PATH : ${tk}/bin"
     '' else "")

   + ''# Wrap `git-clone'
       wrapArgs="$wrapArgs --prefix PATH : ${cpio}/bin"

       for b in $out/bin/{git,gitk}; do
         [ -f "$b" ] && eval "wrapProgram $b $wrapArgs"
       done
     ''

   + ''# install bash completion script
      d="$out/etc/bash_completion.d"
      ensureDir $d; cp contrib/completion/git-completion.bash "$d"
     '';

  meta = {
    license = "GPLv2";
    homepage = http://git.or.cz;
    description = "Git, a popular distributed version control system";

    longDescription = ''
      Git, a popular distributed version control system designed to
      handle very large projects with speed and efficiency.
    '';

  };
}
