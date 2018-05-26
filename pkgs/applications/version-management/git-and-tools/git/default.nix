{ fetchurl, stdenv, buildPackages
, curl, openssl, zlib, expat, perl, python, gettext, cpio
, gnugrep, gnused, gawk, coreutils # needed at runtime by git-filter-branch etc
, openssh, pcre2
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_45
, libxslt, tcl, tk, makeWrapper, libiconv
, svnSupport, subversionClient, perlLibs, smtpPerlLibs
, perlSupport ? true
, guiSupport
, withManual ? true
, pythonSupport ? true
, withpcre2 ? true
, sendEmailSupport
, darwin
}:

assert sendEmailSupport -> perlSupport;
assert svnSupport -> perlSupport;

let
  version = "2.16.3";
  svn = subversionClient.override { perlBindings = perlSupport; };
in

stdenv.mkDerivation {
  name = "git-${version}";

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/scm/git/git-${version}.tar.xz";
    sha256 = "0j1dwvg5llnj3g0fp8hdgpms4hp90qw9f6509vqw30dhwplrjpfn";
  };

  outputs = [ "out" ] ++ stdenv.lib.optional perlSupport "gitweb";

  hardeningDisable = [ "format" ];

  patches = [
    ./docbook2texi.patch
    ./symlinks-in-bin.patch
    ./git-sh-i18n.patch
    ./ssh-path.patch
    ./git-send-email-honor-PATH.patch
  ];

  postPatch = ''
    for x in connect.c git-gui/lib/remote_add.tcl ; do
      substituteInPlace "$x" \
        --subst-var-by ssh "${openssh}/bin/ssh"
    done
  '';

  nativeBuildInputs = [ gettext perl ]
    ++ stdenv.lib.optionals withManual [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_45 libxslt ];
  buildInputs = [curl openssl zlib expat cpio makeWrapper libiconv]
    ++ stdenv.lib.optionals perlSupport [ perl ]
    ++ stdenv.lib.optionals guiSupport [tcl tk]
    ++ stdenv.lib.optionals withpcre2 [ pcre2 ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ darwin.Security ];


  # required to support pthread_cancel()
  NIX_LDFLAGS = stdenv.lib.optionalString (!stdenv.cc.isClang) "-lgcc_s"
              + stdenv.lib.optionalString (stdenv.isFreeBSD) "-lthr";

  configureFlags = stdenv.lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_fread_reads_directories=yes"
    "ac_cv_snprintf_returns_bogus=no"
  ];

  makeFlags = [
    "prefix=\${out}"
    "SHELL_PATH=${stdenv.shell}"
  ]
  ++ (if perlSupport then ["PERL_PATH=${perl}/bin/perl"] else ["NO_PERL=1"])
  ++ (if pythonSupport then ["PYTHON_PATH=${python}/bin/python"] else ["NO_PYTHON=1"])
  ++ stdenv.lib.optionals stdenv.isSunOS ["INSTALL=install" "NO_INET_NTOP=" "NO_INET_PTON="]
  ++ (if stdenv.isDarwin then ["NO_APPLE_COMMON_CRYPTO=1"] else ["sysconfdir=/etc/"])
  ++ stdenv.lib.optionals stdenv.hostPlatform.isMusl ["NO_SYS_POLL_H=1" "NO_GETTEXT=YesPlease"]
  ++ stdenv.lib.optional withpcre2 "USE_LIBPCRE2=1";

  # build git-credential-osxkeychain if darwin
  postBuild = stdenv.lib.optionalString stdenv.isDarwin ''
    pushd $PWD/contrib/credential/osxkeychain/
    make
    popd
  '';

  # FIXME: "make check" requires Sparse; the Makefile must be tweaked
  # so that `SPARSE_FLAGS' corresponds to the current architecture...
  #doCheck = true;

  installFlags = "NO_INSTALL_HARDLINKS=1";

  preInstall = stdenv.lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/bin
    mv $PWD/contrib/credential/osxkeychain/git-credential-osxkeychain $out/bin
  '';

  postInstall =
    ''
      notSupported() {
        unlink $1 || true
      }

      # Install git-subtree.
      pushd contrib/subtree
      make
      make install ${stdenv.lib.optionalString withManual "install-doc"}
      popd
      rm -rf contrib/subtree

      # Install contrib stuff.
      mkdir -p $out/share/git
      mv contrib $out/share/git/
      ln -s "$out/share/git/contrib/credential/netrc/git-credential-netrc" $out/bin/
      mkdir -p $out/share/emacs/site-lisp
      ln -s "$out/share/git/contrib/emacs/"*.el $out/share/emacs/site-lisp/
      mkdir -p $out/etc/bash_completion.d
      ln -s $out/share/git/contrib/completion/git-completion.bash $out/etc/bash_completion.d/
      ln -s $out/share/git/contrib/completion/git-prompt.sh $out/etc/bash_completion.d/

      # grep is a runtime dependency, need to patch so that it's found
      substituteInPlace $out/libexec/git-core/git-sh-setup \
          --replace ' grep' ' ${gnugrep}/bin/grep' \
          --replace ' egrep' ' ${gnugrep}/bin/egrep'

      # Fix references to the perl, sed, awk and various coreutil binaries used by
      # shell scripts that git calls (e.g. filter-branch)
      SCRIPT="$(cat <<'EOS'
        BEGIN{
          @a=(
            '${gnugrep}/bin/grep', '${gnused}/bin/sed', '${gawk}/bin/awk',
            '${coreutils}/bin/cut', '${coreutils}/bin/basename', '${coreutils}/bin/dirname',
            '${coreutils}/bin/wc', '${coreutils}/bin/tr'
            ${stdenv.lib.optionalString perlSupport ", '${perl}/bin/perl'"}
          );
        }
        foreach $c (@a) {
          $n=(split("/", $c))[-1];
          s|(?<=[^#][^/.-])\b''${n}(?=\s)|''${c}|g
        }
      EOS
      )"
      perl -0777 -i -pe "$SCRIPT" \
        $out/libexec/git-core/git-{sh-setup,filter-branch,merge-octopus,mergetool,quiltimport,request-pull,stash,submodule,subtree,web--browse}

      # Fix references to gettext.
      substituteInPlace $out/libexec/git-core/git-sh-i18n \
          --subst-var-by gettext ${gettext}

      # Also put git-http-backend into $PATH, so that we can use smart
      # HTTP(s) transports for pushing
      ln -s $out/libexec/git-core/git-http-backend $out/bin/git-http-backend
    '' + stdenv.lib.optionalString perlSupport ''
      # put in separate package for simpler maintenance
      mv $out/share/gitweb $gitweb/

      # wrap perl commands
      gitperllib=$out/lib/perl5/site_perl
      for i in ${builtins.toString perlLibs}; do
        gitperllib=$gitperllib:$i/lib/perl5/site_perl
      done
      wrapProgram $out/libexec/git-core/git-cvsimport \
                  --set GITPERLLIB "$gitperllib"
      wrapProgram $out/libexec/git-core/git-add--interactive \
                  --set GITPERLLIB "$gitperllib"
      wrapProgram $out/libexec/git-core/git-archimport \
                  --set GITPERLLIB "$gitperllib"
      wrapProgram $out/libexec/git-core/git-instaweb \
                  --set GITPERLLIB "$gitperllib"
      wrapProgram $out/libexec/git-core/git-cvsexportcommit \
                  --set GITPERLLIB "$gitperllib"
    ''

   + (if svnSupport then

      ''# wrap git-svn
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString perlLibs} ${svn.out}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram $out/libexec/git-core/git-svn     \
                     --set GITPERLLIB "$gitperllib"   \
                     --prefix PATH : "${svn.out}/bin" ''
       else '' # replace git-svn by notification script
        notSupported $out/libexec/git-core/git-svn
       '')

   + (if sendEmailSupport then
      ''# wrap git-send-email
        gitperllib=$out/lib/perl5/site_perl
        for i in ${builtins.toString smtpPerlLibs}; do
          gitperllib=$gitperllib:$i/lib/perl5/site_perl
        done
        wrapProgram $out/libexec/git-core/git-send-email \
                     --set GITPERLLIB "$gitperllib" ''
       else '' # replace git-send-email by notification script
        notSupported $out/libexec/git-core/git-send-email
       '')

   + stdenv.lib.optionalString withManual ''# Install man pages and Info manual
       make -j $NIX_BUILD_CORES -l $NIX_BUILD_CORES PERL_PATH="${buildPackages.perl}/bin/perl" cmd-list.made install install-info \
         -C Documentation ''

   + (if guiSupport then ''
       # Wrap Tcl/Tk programs
       for prog in bin/gitk libexec/git-core/{git-gui,git-citool,git-gui--askpass}; do
         sed -i -e "s|exec 'wish'|exec '${tk}/bin/wish'|g" \
                -e "s|exec wish|exec '${tk}/bin/wish'|g" \
                "$out/$prog"
       done
     '' else ''
       # Don't wrap Tcl/Tk, replace them by notification scripts
       for prog in bin/gitk libexec/git-core/git-gui; do
         notSupported "$out/$prog"
       done
     '')
   + stdenv.lib.optionalString stdenv.isDarwin ''
    # enable git-credential-osxkeychain by default if darwin
    cat > $out/etc/gitconfig << EOF
[credential]
	helper = osxkeychain
EOF
  '';


  enableParallelBuilding = true;

  meta = {
    homepage = https://git-scm.com/;
    description = "Distributed version control system";
    license = stdenv.lib.licenses.gpl2;

    longDescription = ''
      Git, a popular distributed version control system designed to
      handle very large projects with speed and efficiency.
    '';

    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ peti the-kenny wmertens ];
  };
}
