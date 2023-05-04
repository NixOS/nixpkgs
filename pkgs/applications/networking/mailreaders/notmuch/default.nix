{ fetchurl, lib, stdenv
, pkg-config, gnupg
, xapian, gmime3, talloc, zlib
, doxygen, perl, texinfo
, notmuch
, pythonPackages
, emacs
, ruby
, testers
, which, dtach, openssl, bash, gdb, man
, withEmacs ? true
, withRuby ? true
}:

stdenv.mkDerivation rec {
  pname = "notmuch";
  version = "0.37";

  src = fetchurl {
    url = "https://notmuchmail.org/releases/notmuch-${version}.tar.xz";
    sha256 = "sha256-DnZt8ot4v064I1Ymqx9S8E8eNmZJMlqM6NPJCGAnhvY=";
  };

  nativeBuildInputs = [
    pkg-config
    doxygen                   # (optional) api docs
    pythonPackages.sphinx     # (optional) documentation -> doc/INSTALL
    texinfo                   # (optional) documentation -> doc/INSTALL
    pythonPackages.cffi
  ] ++ lib.optional withEmacs emacs
    ++ lib.optional withRuby ruby;

  buildInputs = [
    gnupg                     # undefined dependencies
    xapian gmime3 talloc zlib  # dependencies described in INSTALL
    perl
    pythonPackages.python
  ] ++ lib.optional withRuby ruby;

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

  preCheck = let
    test-database = fetchurl {
      url = "https://notmuchmail.org/releases/test-databases/database-v1.tar.xz";
      sha256 = "1lk91s00y4qy4pjh8638b5lfkgwyl282g1m27srsf7qfn58y16a2";
    };
  in ''
    mkdir -p test/test-databases
    ln -s ${test-database} test/test-databases/database-v1.tar.xz
  '';

  doCheck = !stdenv.hostPlatform.isDarwin && (lib.versionAtLeast gmime3.version "3.0.3");
  checkTarget = "test";
  nativeCheckInputs = [
    which dtach openssl bash
    gdb man emacs
  ];

  installTargets = [ "install" "install-man" "install-info" ];

  postInstall = lib.optionalString withEmacs ''
    moveToOutput bin/notmuch-emacs-mua $emacs
  '' + lib.optionalString withRuby ''
    make -C bindings/ruby install \
      vendordir=$ruby/lib/ruby \
      SHELL=$SHELL \
      $makeFlags "''${makeFlagsArray[@]}" \
      $installFlags "''${installFlagsArray[@]}"
  '';

  passthru = {
    pythonSourceRoot = "notmuch-${version}/bindings/python";
    tests.version = testers.testVersion { package = notmuch; };
    inherit version;
  };

  meta = with lib; {
    description = "Mail indexer";
    homepage    = "https://notmuchmail.org/";
    license     = licenses.gpl3Plus;
    maintainers = with maintainers; [ flokli puckipedia ];
    platforms   = platforms.unix;
  };
}
