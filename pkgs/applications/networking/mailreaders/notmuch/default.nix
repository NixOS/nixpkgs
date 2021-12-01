{ fetchurl, lib, stdenv
, pkg-config, gnupg
, xapian, gmime, talloc, zlib
, doxygen, perl, texinfo
, pythonPackages
, emacs
, ruby
, which, dtach, openssl, bash, gdb, man
, withEmacs ? true
}:

stdenv.mkDerivation rec {
  pname = "notmuch";
  version = "0.34.1";

  src = fetchurl {
    url = "https://notmuchmail.org/releases/notmuch-${version}.tar.xz";
    sha256 = "05nq64gp8vnrwrl22d60v7ixgdhm9339ajhcdfkq0ll1qiycyyj5";
  };

  nativeBuildInputs = [
    pkg-config
    doxygen                   # (optional) api docs
    pythonPackages.sphinx     # (optional) documentation -> doc/INSTALL
    texinfo                   # (optional) documentation -> doc/INSTALL
    pythonPackages.cffi
  ] ++ lib.optional withEmacs emacs;

  buildInputs = [
    gnupg                     # undefined dependencies
    xapian gmime talloc zlib  # dependencies described in INSTALL
    perl
    pythonPackages.python
    ruby
  ];

  postPatch = ''
    patchShebangs configure test/

    substituteInPlace lib/Makefile.local \
      --replace '-install_name $(libdir)' "-install_name $out/lib"
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
    ++ lib.optional (isNull ruby) "--without-ruby";

  # Notmuch doesn't use autoconf and consequently doesn't tag --bindir and
  # friends
  setOutputFlags = false;
  enableParallelBuilding = true;
  makeFlags = [ "V=1" ];

  outputs = [ "out" "man" "info" ] ++ lib.optional withEmacs "emacs";

  preCheck = let
    test-database = fetchurl {
      url = "https://notmuchmail.org/releases/test-databases/database-v1.tar.xz";
      sha256 = "1lk91s00y4qy4pjh8638b5lfkgwyl282g1m27srsf7qfn58y16a2";
    };
  in ''
    mkdir -p test/test-databases
    ln -s ${test-database} test/test-databases/database-v1.tar.xz
  '';

  doCheck = !stdenv.hostPlatform.isDarwin && (lib.versionAtLeast gmime.version "3.0.3");
  checkTarget = "test";
  checkInputs = [
    which dtach openssl bash
    gdb man emacs
  ];

  installTargets = [ "install" "install-man" "install-info" ];

  postInstall = lib.optionalString withEmacs ''
    moveToOutput bin/notmuch-emacs-mua $emacs
  '';

  passthru = {
    pythonSourceRoot = "notmuch-${version}/bindings/python";
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
