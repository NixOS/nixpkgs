{ fetchurl, lib, stdenv, makeWrapper
, pkg-config, gnupg
, xapian, gmime3, sfsexp, talloc, zlib
, doxygen, perl, texinfo
, notmuch
, pythonPackages
, emacs
, ruby
, testers
, gitUpdater
, which, dtach, openssl, bash, gdb, man, git
, withEmacs ? true
, withRuby ? true
, withSfsexp ? true # also installs notmuch-git, which requires sexp-support
}:

stdenv.mkDerivation rec {
  pname = "notmuch";
  version = "0.38";

  src = fetchurl {
    url = "https://notmuchmail.org/releases/notmuch-${version}.tar.xz";
    sha256 = "sha256-oXkBrb5D9IGmv1PBWiogJovI3HrVzPaFoNF8FFbbr24=";
  };

  nativeBuildInputs = [
    pkg-config
    doxygen                   # (optional) api docs
    pythonPackages.sphinx     # (optional) documentation -> doc/INSTALL
    texinfo                   # (optional) documentation -> doc/INSTALL
    pythonPackages.cffi
  ] ++ lib.optional withEmacs emacs
    ++ lib.optional withRuby ruby
    ++ lib.optional withSfsexp makeWrapper;

  buildInputs = [
    gnupg                     # undefined dependencies
    xapian gmime3 talloc zlib  # dependencies described in INSTALL
    perl
    pythonPackages.python
  ] ++ lib.optional withRuby ruby
    ++ lib.optional withSfsexp sfsexp;

  postPatch = ''
    patchShebangs configure test/

    substituteInPlace lib/Makefile.local \
      --replace '-install_name $(libdir)' "-install_name $out/lib"

    # do not override CFLAGS of the Makefile created by mkmf
    substituteInPlace bindings/Makefile.local \
      --replace 'CFLAGS="$(CFLAGS) -pipe -fno-plt -fPIC"' ""
  '' + lib.optionalString withEmacs ''
    substituteInPlace emacs/notmuch-emacs-mua \
      --replace 'EMACS:-emacs' 'EMACS:-${emacs}/bin/emacs' \
      --replace 'EMACSCLIENT:-emacsclient' 'EMACSCLIENT:-${emacs}/bin/emacsclient'
  '';

  configureFlags = [
    "--zshcompletiondir=${placeholder "out"}/share/zsh/site-functions"
    "--bashcompletiondir=${placeholder "out"}/share/bash-completion/completions"
    "--infodir=${placeholder "info"}/share/info"
  ] ++ lib.optional (!withEmacs) "--without-emacs"
    ++ lib.optional withEmacs "--emacslispdir=${placeholder "emacs"}/share/emacs/site-lisp"
    ++ lib.optional (!withRuby) "--without-ruby";

  # Notmuch doesn't use autoconf and consequently doesn't tag --bindir and
  # friends
  setOutputFlags = false;
  enableParallelBuilding = true;
  makeFlags = [ "V=1" ];

  postConfigure = ''
    mkdir ${placeholder "bindingconfig"}
    cp bindings/python-cffi/_notmuch_config.py ${placeholder "bindingconfig"}/
  '';

  outputs = [ "out" "man" "info" "bindingconfig" ]
    ++ lib.optional withEmacs "emacs"
    ++ lib.optional withRuby "ruby";

  # if notmuch is built with s-expression support, the testsuite (T-850.sh) only
  # passes if notmuch-git can be executed, so we need to patch its shebang.
  postBuild = lib.optionalString withSfsexp ''
    patchShebangs notmuch-git
  '';

  preCheck = let
    test-database = fetchurl {
      url = "https://notmuchmail.org/releases/test-databases/database-v1.tar.xz";
      sha256 = "1lk91s00y4qy4pjh8638b5lfkgwyl282g1m27srsf7qfn58y16a2";
    };
  in ''
    mkdir -p test/test-databases
    ln -s ${test-database} test/test-databases/database-v1.tar.xz
  ''
  # Issues since gnupg: 2.4.0 -> 2.4.1
  + ''
    rm test/{T350-crypto,T357-index-decryption}.sh
  '';

  doCheck = !stdenv.hostPlatform.isDarwin && (lib.versionAtLeast gmime3.version "3.0.3");
  checkTarget = "test";
  nativeCheckInputs = [
    which dtach openssl bash
    gdb man
  ]
  # for the test T-850.sh for notmuch-git, which is skipped when notmuch is
  # built without sexp-support
  ++ lib.optional withEmacs emacs
  ++ lib.optional withSfsexp git;

  installTargets = [ "install" "install-man" "install-info" ];

  postInstall = lib.optionalString withEmacs ''
    moveToOutput bin/notmuch-emacs-mua $emacs
  '' + lib.optionalString withRuby ''
    make -C bindings/ruby install \
      vendordir=$ruby/lib/ruby \
      SHELL=$SHELL \
      $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
  ''
  # notmuch-git (https://notmuchmail.org/doc/latest/man1/notmuch-git.html) does not work without
  # sexp-support, so there is no point in installing if we're building without it.
  + lib.optionalString withSfsexp ''
    cp notmuch-git $out/bin/notmuch-git
    wrapProgram $out/bin/notmuch-git --prefix PATH : $out/bin:${lib.getBin git}/bin
  '';

  passthru = {
    pythonSourceRoot = "notmuch-${version}/bindings/python";
    tests.version = testers.testVersion { package = notmuch; };
    inherit version;

    updateScript = gitUpdater {
      url = "https://git.notmuchmail.org/git/notmuch";
      ignoredVersions = "_rc.*";
    };
  };

  meta = with lib; {
    description = "Mail indexer";
    homepage    = "https://notmuchmail.org/";
    changelog   = "https://git.notmuchmail.org/git?p=notmuch;a=blob_plain;f=NEWS;hb=${version}";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ flokli puckipedia ];
    platforms   = platforms.unix;
  };
}
