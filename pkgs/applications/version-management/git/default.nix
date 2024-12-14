{ fetchurl, fetchpatch, lib, stdenv, buildPackages
, curl, openssl, zlib, expat, perlPackages, python3, gettext, cpio
, gnugrep, gnused, gawk, coreutils # needed at runtime by git-filter-branch etc
, openssh, pcre2, bash
, asciidoc, texinfo, xmlto, docbook2x, docbook_xsl, docbook_xml_dtd_45
, libxslt, tcl, tk, makeWrapper, libiconv, libiconvReal
, svnSupport ? false, subversionClient, perlLibs, smtpPerlLibs
, perlSupport ? stdenv.buildPlatform == stdenv.hostPlatform
, nlsSupport ? true
, osxkeychainSupport ? stdenv.hostPlatform.isDarwin
, guiSupport ? false
, withManual ? true
, pythonSupport ? true
, withpcre2 ? true
, sendEmailSupport ? perlSupport
, Security, CoreServices
, nixosTests
, withLibsecret ? false
, pkg-config, glib, libsecret
, gzip # needed at runtime by gitweb.cgi
, withSsh ? false
, sysctl
, deterministic-host-uname # trick Makefile into targeting the host platform when cross-compiling
, doInstallCheck ? !stdenv.hostPlatform.isDarwin  # extremely slow on darwin
, tests
}:

assert osxkeychainSupport -> stdenv.hostPlatform.isDarwin;
assert sendEmailSupport -> perlSupport;
assert svnSupport -> perlSupport;

let
  version = "2.47.0";
  svn = subversionClient.override { perlBindings = perlSupport; };
  gitwebPerlLibs = with perlPackages; [ CGI HTMLParser CGIFast FCGI FCGIProcManager HTMLTagCloud ];
in

stdenv.mkDerivation (finalAttrs: {
  pname = "git"
    + lib.optionalString svnSupport "-with-svn"
    + lib.optionalString (!svnSupport && !guiSupport && !sendEmailSupport && !withManual && !pythonSupport && !withpcre2) "-minimal";
  inherit version;

  src = fetchurl {
    url = "https://www.kernel.org/pub/software/scm/git/git-${version}.tar.xz";
    hash = "sha256-HOEU2ohwQnG0PgJ8UeBNk5n4yI6e91Qtrnrrrn2HvE4=";
  };

  outputs = [ "out" ] ++ lib.optional withManual "doc";
  separateDebugInfo = true;

  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  patches = [
    ./docbook2texi.patch
    ./git-sh-i18n.patch
    ./git-send-email-honor-PATH.patch
    ./installCheck-path.patch
  ] ++ lib.optionals withSsh [
    ./ssh-path.patch
  ] ++ lib.optionals (guiSupport && stdenv.hostPlatform.isDarwin) [
    # Needed to workaround an issue in macOS where gitk shows a empty window
    # https://github.com/Homebrew/homebrew-core/issues/68798
    # https://github.com/git/git/pull/944
    (fetchpatch {
      name = "gitk_check_main_window_visibility_before_waiting_for_it_to_show.patch";
      url = "https://github.com/git/git/commit/1db62e44b7ec93b6654271ef34065b31496cd02e.patch";
      hash = "sha256-ntvnrYFFsJ1Ebzc6vM9/AMFLHMS1THts73PIOG5DkQo=";
    })
  ];

  postPatch = ''
    # Fix references to gettext introduced by ./git-sh-i18n.patch
    substituteInPlace git-sh-i18n.sh \
        --subst-var-by gettext ${gettext}

    # ensure we are using the correct shell when executing the test scripts
    patchShebangs t/*.sh
  '' + lib.optionalString withSsh ''
    for x in connect.c git-gui/lib/remote_add.tcl ; do
      substituteInPlace "$x" \
        --subst-var-by ssh "${openssh}/bin/ssh"
    done
  '';

  nativeBuildInputs = [ deterministic-host-uname gettext perlPackages.perl makeWrapper pkg-config ]
    ++ lib.optionals withManual [ asciidoc texinfo xmlto docbook2x
         docbook_xsl docbook_xml_dtd_45 libxslt ];
  buildInputs = [ curl openssl zlib expat cpio (if stdenv.hostPlatform.isFreeBSD then libiconvReal else libiconv) bash ]
    ++ lib.optionals perlSupport [ perlPackages.perl ]
    ++ lib.optionals guiSupport [tcl tk]
    ++ lib.optionals withpcre2 [ pcre2 ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ Security CoreServices ]
    ++ lib.optionals withLibsecret [ glib libsecret ];

  # required to support pthread_cancel()
  NIX_LDFLAGS = lib.optionalString (stdenv.cc.isGNU && stdenv.hostPlatform.libc == "glibc") "-lgcc_s"
              + lib.optionalString (stdenv.hostPlatform.isFreeBSD) "-lthr";

  configureFlags = [
    "ac_cv_prog_CURL_CONFIG=${lib.getDev curl}/bin/curl-config"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "ac_cv_fread_reads_directories=yes"
    "ac_cv_snprintf_returns_bogus=no"
    "ac_cv_iconv_omits_bom=no"
  ];

  preBuild = ''
    makeFlagsArray+=( perllibdir=$out/$(perl -MConfig -wle 'print substr $Config{installsitelib}, 1 + length $Config{siteprefixexp}') )
  '';

  makeFlags = [
    "prefix=\${out}"
  ]
  # Git does not allow setting a shell separately for building and run-time.
  # Therefore lets leave it at the default /bin/sh when cross-compiling
  ++ lib.optional (stdenv.buildPlatform == stdenv.hostPlatform) "SHELL_PATH=${stdenv.shell}"
  ++ (if perlSupport then ["PERL_PATH=${perlPackages.perl}/bin/perl"] else ["NO_PERL=1"])
  ++ (if pythonSupport then ["PYTHON_PATH=${python3}/bin/python"] else ["NO_PYTHON=1"])
  ++ lib.optionals stdenv.hostPlatform.isSunOS ["INSTALL=install" "NO_INET_NTOP=" "NO_INET_PTON="]
  ++ (if stdenv.hostPlatform.isDarwin then ["NO_APPLE_COMMON_CRYPTO=1"] else ["sysconfdir=/etc"])
  ++ lib.optionals stdenv.hostPlatform.isMusl ["NO_SYS_POLL_H=1" "NO_GETTEXT=YesPlease"]
  ++ lib.optional withpcre2 "USE_LIBPCRE2=1"
  ++ lib.optional (!nlsSupport) "NO_GETTEXT=1"
  # git-gui refuses to start with the version of tk distributed with
  # macOS Catalina. We can prevent git from building the .app bundle
  # by specifying an invalid tk framework. The postInstall step will
  # then ensure that git-gui uses tcl/tk from nixpkgs, which is an
  # acceptable version.
  #
  # See https://github.com/Homebrew/homebrew-core/commit/dfa3ccf1e7d3901e371b5140b935839ba9d8b706
  ++ lib.optional stdenv.hostPlatform.isDarwin "TKFRAMEWORK=/nonexistent";

  disallowedReferences = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    stdenv.shellPackage
  ];


  postBuild = ''
    make -C contrib/subtree
  '' + (lib.optionalString perlSupport ''
    make -C contrib/diff-highlight
  '') + (lib.optionalString osxkeychainSupport ''
    make -C contrib/credential/osxkeychain
  '') + (lib.optionalString withLibsecret ''
    make -C contrib/credential/libsecret
  '');


  ## Install

  # WARNING: Do not `rm` or `mv` files from the source tree; use `cp` instead.
  #          We need many of these files during the installCheckPhase.

  installFlags = [ "NO_INSTALL_HARDLINKS=1" ];

  preInstall = (lib.optionalString osxkeychainSupport ''
    mkdir -p $out/bin
    ln -s $out/share/git/contrib/credential/osxkeychain/git-credential-osxkeychain $out/bin/
    rm -f $PWD/contrib/credential/osxkeychain/git-credential-osxkeychain.o
  '') + (lib.optionalString withLibsecret ''
    mkdir -p $out/bin
    ln -s $out/share/git/contrib/credential/libsecret/git-credential-libsecret $out/bin/
    rm -f $PWD/contrib/credential/libsecret/git-credential-libsecret.o
  '');

  postInstall =
    ''
      notSupported() {
        unlink $1 || true
      }

      # Install git-subtree.
      make -C contrib/subtree install ${lib.optionalString withManual "install-doc"}
      rm -rf contrib/subtree

      # Install contrib stuff.
      mkdir -p $out/share/git
      cp -a contrib $out/share/git/
      mkdir -p $out/share/bash-completion/completions
      ln -s $out/share/git/contrib/completion/git-completion.bash $out/share/bash-completion/completions/git
      ln -s $out/share/git/contrib/completion/git-prompt.sh $out/share/bash-completion/completions/
      # only readme, developed in another repo
      rm -r contrib/hooks/multimail
      mkdir -p $out/share/git-core/contrib
      cp -a contrib/hooks/ $out/share/git-core/contrib/
      substituteInPlace $out/share/git-core/contrib/hooks/pre-auto-gc-battery \
        --replace ' grep' ' ${gnugrep}/bin/grep' \

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
            ${lib.optionalString perlSupport ", '${perlPackages.perl}/bin/perl'"}
          );
        }
        foreach $c (@a) {
          $n=(split("/", $c))[-1];
          s|(?<=[^#][^/.-])\b''${n}(?=\s)|''${c}|g
        }
      EOS
      )"
      perl -0777 -i -pe "$SCRIPT" \
        $out/libexec/git-core/git-{sh-setup,filter-branch,merge-octopus,mergetool,quiltimport,request-pull,submodule,subtree,web--browse}


      # Also put git-http-backend into $PATH, so that we can use smart
      # HTTP(s) transports for pushing
      ln -s $out/libexec/git-core/git-http-backend $out/bin/git-http-backend
      ln -s $out/share/git/contrib/git-jump/git-jump $out/bin/git-jump
    '' + lib.optionalString perlSupport ''
      # wrap perl commands
      makeWrapper "$out/share/git/contrib/credential/netrc/git-credential-netrc.perl" $out/bin/git-credential-netrc \
                  --set PERL5LIB   "$out/${perlPackages.perl.libPrefix}:${perlPackages.makePerlPath perlLibs}"
      wrapProgram $out/libexec/git-core/git-cvsimport \
                  --set GITPERLLIB "$out/${perlPackages.perl.libPrefix}:${perlPackages.makePerlPath perlLibs}"
      wrapProgram $out/libexec/git-core/git-archimport \
                  --set GITPERLLIB "$out/${perlPackages.perl.libPrefix}:${perlPackages.makePerlPath perlLibs}"
      wrapProgram $out/libexec/git-core/git-instaweb \
                  --set GITPERLLIB "$out/${perlPackages.perl.libPrefix}:${perlPackages.makePerlPath perlLibs}"
      wrapProgram $out/libexec/git-core/git-cvsexportcommit \
                  --set GITPERLLIB "$out/${perlPackages.perl.libPrefix}:${perlPackages.makePerlPath perlLibs}"

      # gzip (and optionally bzip2, xz, zip) are runtime dependencies for
      # gitweb.cgi, need to patch so that it's found
      sed -i -e "s|'compressor' => \['gzip'|'compressor' => ['${gzip}/bin/gzip'|" \
          $out/share/gitweb/gitweb.cgi
      # Give access to CGI.pm and friends (was removed from perl core in 5.22)
      for p in ${lib.concatStringsSep " " gitwebPerlLibs}; do
          sed -i -e "/use CGI /i use lib \"$p/${perlPackages.perl.libPrefix}\";" \
              "$out/share/gitweb/gitweb.cgi"
      done
    ''

   + (if svnSupport then ''
        # wrap git-svn
        wrapProgram $out/libexec/git-core/git-svn \
          --set GITPERLLIB "$out/${perlPackages.perl.libPrefix}:${perlPackages.makePerlPath (perlLibs ++ [svn.out])}" \
          --prefix PATH : "${svn.out}/bin"
      '' else ''
        # replace git-svn by notification script
        notSupported $out/libexec/git-core/git-svn
     '')

   + (if sendEmailSupport then ''
        # wrap git-send-email
        wrapProgram $out/libexec/git-core/git-send-email \
                     --set GITPERLLIB "$out/${perlPackages.perl.libPrefix}:${perlPackages.makePerlPath smtpPerlLibs}"
      '' else ''
        # replace git-send-email by notification script
        notSupported $out/libexec/git-core/git-send-email
      '')

   + lib.optionalString withManual ''
       # Install man pages
       make -j $NIX_BUILD_CORES PERL_PATH="${buildPackages.perl}/bin/perl" cmd-list.made install install-html \
         -C Documentation
     ''

   + (if guiSupport then ''
       # Wrap Tcl/Tk programs
       for prog in bin/gitk libexec/git-core/{git-gui,git-citool,git-gui--askpass}; do
         sed -i -e "s|exec 'wish'|exec '${tk}/bin/wish'|g" \
                -e "s|exec wish|exec '${tk}/bin/wish'|g" \
                "$out/$prog"
       done
       ln -s $out/share/git/contrib/completion/git-completion.bash $out/share/bash-completion/completions/gitk
     '' else ''
       # Don't wrap Tcl/Tk, replace them by notification scripts
       for prog in bin/gitk libexec/git-core/git-gui; do
         notSupported "$out/$prog"
       done
     '')
   + lib.optionalString osxkeychainSupport ''
    # enable git-credential-osxkeychain on darwin if desired (default)
    mkdir -p $out/etc
    cat > $out/etc/gitconfig << EOF
    [credential]
      helper = osxkeychain
    EOF
  '';


  ## InstallCheck

  doCheck = false;
  inherit doInstallCheck;

  installCheckTarget = "test";

  # see also installCheckFlagsArray
  installCheckFlags = [
    "DEFAULT_TEST_TARGET=prove"
    "PERL_PATH=${buildPackages.perl}/bin/perl"
  ];

  nativeInstallCheckInputs = lib.optional (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isFreeBSD) sysctl;

  preInstallCheck = ''
    installCheckFlagsArray+=(
      GIT_PROVE_OPTS="--jobs $NIX_BUILD_CORES --failures --state=failed,save"
      GIT_TEST_INSTALLED=$out/bin
      ${lib.optionalString (!svnSupport) "NO_SVN_TESTS=y"}
    )

    function disable_test {
      local test=$1 pattern=$2
      if [ $# -eq 1 ]; then
        mv t/{,skip-}$test.sh || true
      else
        sed -i t/$test.sh \
          -e "/^\s*test_expect_.*$pattern/,/^\s*' *\$/{s/^/: #/}"
      fi
    }

    # Shared permissions are forbidden in sandbox builds:
    substituteInPlace t/test-lib.sh \
      --replace "test_set_prereq POSIXPERM" ""
    # TODO: Investigate while these still fail (without POSIXPERM):
    # Tested to fail: 2.46.0
    disable_test t0001-init 'shared overrides system'
    # Tested to fail: 2.46.0
    disable_test t0001-init 'init honors global core.sharedRepository'
    # Tested to fail: 2.46.0
    disable_test t1301-shared-repo
    # /build/git-2.44.0/contrib/completion/git-completion.bash: line 452: compgen: command not found
    disable_test t9902-completion

    # Our patched gettext never fallbacks
    disable_test t0201-gettext-fallbacks
  '' + lib.optionalString (!sendEmailSupport) ''
    # Disable sendmail tests
    disable_test t9001-send-email
  '' + ''
    # Flaky tests:
    disable_test t6421-merge-partial-clone

    # Fails reproducibly on ZFS on Linux with formD normalization
    disable_test t0021-conversion
    disable_test t3910-mac-os-precompose
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # XXX: Some tests added in 2.24.0 fail.
    # Please try to re-enable on the next release.
    disable_test t7816-grep-binary-pattern
    # fail (as of 2.33.0)
    #===(   18623;1208  8/?  224/?  2/? )= =fatal: Not a valid object name refs/tags/signed-empty
    disable_test t6300-for-each-ref
    # not ok 1 - populate workdir (with 2.33.1 on x86_64-darwin)
    disable_test t5003-archive-zip
  '' + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) ''
    disable_test t7527-builtin-fsmonitor
  '' + lib.optionalString stdenv.hostPlatform.isMusl ''
    # Test fails (as of 2.17.0, musl 1.1.19)
    disable_test t3900-i18n-commit
    # Fails largely due to assumptions about BOM
    # Tested to fail: 2.18.0
    disable_test t0028-working-tree-encoding
  '';

  stripDebugList = [ "lib" "libexec" "bin" "share/git/contrib/credential/libsecret" ];

  passthru = {
    shellPath = "/bin/git-shell";
    tests = {
      withInstallCheck = finalAttrs.finalPackage.overrideAttrs (_: {
        doInstallCheck = true;
      });
      buildbot-integration = nixosTests.buildbot;
    } // tests.fetchgit;
    updateScript = ./update.sh;
  };

  meta = {
    homepage = "https://git-scm.com/";
    description = "Distributed version control system";
    license = lib.licenses.gpl2;
    changelog = "https://github.com/git/git/blob/v${version}/Documentation/RelNotes/${version}.txt";

    longDescription = ''
      Git, a popular distributed version control system designed to
      handle very large projects with speed and efficiency.
    '';

    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ primeos wmertens globin kashw2 ];
    mainProgram = "git";
  };
})
