{ fetchurl, fetchgit, stdenv
, pkgconfig, gnupg
, xapian, gmime, talloc, zlib
, doxygen, perl, texinfo
, pythonPackages
, emacs
, ruby
, which, dtach, openssl, bash, gdb, man
, withEmacs ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.30.1c80020";
  pname = "notmuch";

  passthru = {
    pythonSourceRoot = "${src.name}/bindings/python";
    inherit version;
  };

  src = fetchgit {
    url = "https://git.notmuchmail.org/git/notmuch";
    sha256 = "0xj944c4ayps1bg21pksjih3y9v6lb34dd582df14i14q0yzji51";
    rev = "1c80020e701c7323de137c0616fc8864443d7bd3";
  };

  nativeBuildInputs = [
    pkgconfig
    doxygen                   # (optional) api docs
    pythonPackages.sphinx     # (optional) documentation -> doc/INSTALL
    texinfo                   # (optional) documentation -> doc/INSTALL
  ] ++ optional withEmacs [ emacs ];

  buildInputs = [
    gnupg                     # undefined dependencies
    xapian gmime talloc zlib  # dependencies described in INSTALL
    perl
    pythonPackages.python
    ruby
  ];

  postPatch = ''
    patchShebangs configure
    patchShebangs test/

    substituteInPlace lib/Makefile.local \
      --replace '-install_name $(libdir)' "-install_name $out/lib"
  '' + optionalString withEmacs ''
    substituteInPlace emacs/notmuch-emacs-mua \
      --replace 'EMACS:-emacs' 'EMACS:-${emacs}/bin/emacs' \
      --replace 'EMACSCLIENT:-emacsclient' 'EMACSCLIENT:-${emacs}/bin/emacsclient'
  '';

  configureFlags = [
    "--zshcompletiondir=${placeholder "out"}/share/zsh/site-functions"
    "--bashcompletiondir=${placeholder "out"}/share/bash-completion/completions"
    "--infodir=${placeholder "info"}/share/info"
  ] ++ optional (!withEmacs) "--without-emacs"
    ++ optional (withEmacs) "--emacslispdir=${placeholder "emacs"}/share/emacs/site-lisp"
    ++ optional (isNull ruby) "--without-ruby";

  # Notmuch doesn't use autoconf and consequently doesn't tag --bindir and
  # friends
  setOutputFlags = false;
  enableParallelBuilding = true;
  makeFlags = [ "V=1" ];


  outputs = [ "out" "man" "info" ] ++ stdenv.lib.optional withEmacs "emacs";

  preCheck = let
    test-database = fetchurl {
      url = "https://notmuchmail.org/releases/test-databases/database-v1.tar.xz";
      sha256 = "1lk91s00y4qy4pjh8638b5lfkgwyl282g1m27srsf7qfn58y16a2";
    };
  in ''
    mkdir -p test/test-databases
    ln -s ${test-database} test/test-databases/database-v1.tar.xz
  '';
  doCheck = !stdenv.hostPlatform.isDarwin && (versionAtLeast gmime.version "3.0.3");
  checkTarget = "test";
  checkInputs = [
    which dtach openssl bash
    gdb man emacs
  ];

  installTargets = [ "install" "install-man" "install-info" ];

  postInstall = stdenv.lib.optionalString withEmacs ''
    moveToOutput bin/notmuch-emacs-mua $emacs
  '';

  dontGzipMan = true; # already compressed

  meta = {
    description = "Mail indexer";
    homepage    = "https://notmuchmail.org/";
    license     = licenses.gpl3;
    maintainers = with maintainers; [ flokli puckipedia ];
    platforms   = platforms.unix;
  };
}
