{ fetchurl, stdenv, curl, openssl, zlib, expat, perl, gettext, cpio
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_42
, libxslt, tcl, tk, makeWrapper
, svnSupport, subversion, perlLibs
, guiSupport
, gitkGlobSupport
}:

# `git-svn' support requires Subversion and various Perl libraries.
assert svnSupport -> (subversion != null && perlLibs != [] && subversion.perlBindings);

stdenv.mkDerivation rec {
  name = "git-1.6.4.4";

  src = fetchurl {
    url = "mirror://kernel/software/scm/git/${name}.tar.bz2";
    sha256 = "fc7e4d6c4172c62c93d5e974019f7193b03c8bc0a1c6f3a9fcc1d0928b808d7a";
  };

  patches = [ ./docbook2texi.patch ]
      ++ # adds possibility to highlight all changes to files matching a glob pattern
          stdenv.lib.optional (guiSupport && gitkGlobSupport) (fetchurl {
          url = "http://mawercer.de/~marc/git-jrnieder.patch";
          sha256 = "187wf8chdjifwh3rrdc80nkak08jk7n74xq1bfzr2bhx2wicrv0x";
          });

  buildInputs = [curl openssl zlib expat gettext cpio makeWrapper]
    ++ # documentation tools
       [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_42 libxslt ]
    ++ stdenv.lib.optionals guiSupport [tcl tk];

  makeFlags = "prefix=\${out} PERL_PATH=${perl}/bin/perl SHELL_PATH=${stdenv.shell}";

  # FIXME: "make check" requires Sparse; the Makefile must be tweaked
  # so that `SPARSE_FLAGS' corresponds to the current architecture...
  #doCheck = true;

  postInstall =
    ''
      notSupported(){
        echo -e "#\!/bin/sh\necho '`basename $1` not supported, $2'\nexit 1" > "$1"
        chmod +x $1
      }

      # Install Emacs mode.
      echo "installing Emacs mode..."
      ensureDir $out/share/emacs/site-lisp
      cp -p contrib/emacs/*.el $out/share/emacs/site-lisp
    '' # */

   + (if svnSupport then

      ''# wrap git-svn
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString perlLibs}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram "$out/libexec/git-core/git-svn"     \
                     --set GITPERLLIB "$gitperllib"     \
                     --prefix PATH : "${subversion}/bin" ''
       else '' # replace git-svn by notification script
        notSupported $out/bin/git-svn "reinstall with config git = { svnSupport = true } set"
       '')

   + ''# Install man pages and Info manual
       make PERL_PATH="${perl}/bin/perl" cmd-list.made install install-info \
         -C Documentation ''

   + (if guiSupport then ''
       # Wrap Tcl/Tk programs
       for prog in bin/gitk libexec/git-core/git-gui
       do
         wrapProgram "$out/$prog"                       \
                     --set TK_LIBRARY "${tk}/lib/tk8.4" \
                     --prefix PATH : "${tk}/bin"
       done
     '' else ''
      # Don't wrap Tcl/Tk, replace them by notification scripts
       for prog in bin/gitk libexec/git-core/git-gui
       do
         notSupported "$out/$prog" \
                      "reinstall with config git = { guiSupport = true; } set"
       done
     '')

   + ''# install bash completion script
      d="$out/etc/bash_completion.d"
      ensureDir $d; cp contrib/completion/git-completion.bash "$d"
     ''
   # Don't know why hardlinks aren't created. git installs the same executable multiple times into $out
   # so replace duplicates by symlinks because I haven't tested whether the nix
   # distribution system can handle hardlinks. This reduces the size of $out from 115MB down to 13MB on x86_64-linux!
   + ''#
      set -x
      declare -A seen
      find $out -type f | while read f; do
        sum=$(md5sum "$f");
        sum=''\${sum/ */}
        if [ -z "''\${seen["$sum"]}" ]; then
          seen["$sum"]="$f"
        else
          rm "$f"; ln -s "''\${seen["$sum"]}" "$f"
        fi
      done

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
