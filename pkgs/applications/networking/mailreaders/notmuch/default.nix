{ fetchurl, stdenv
, pkgconfig, gnupg
, xapian, gmime, talloc, zlib
, doxygen, perl, texinfo
, pythonPackages
, bash-completion
, emacs
, ruby
, which, dtach, openssl, bash, gdb, man
, withEmacs ? true
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.29.3";
  pname = "notmuch";

  passthru = {
    pythonSourceRoot = "${pname}-${version}/bindings/python";
    inherit version;
  };

  src = fetchurl {
    url = "https://notmuchmail.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0dfwa38vgnxk9cvvpza66szjgp8lir6iz6yy0cry9593lywh9xym";
  };

  nativeBuildInputs = [
    pkgconfig
    doxygen                   # (optional) api docs
    pythonPackages.sphinx     # (optional) documentation -> doc/INSTALL
    texinfo                   # (optional) documentation -> doc/INSTALL
    bash-completion           # (optional) dependency to install bash completion
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
    "--infodir=${placeholder "info"}"
  ] ++ optional (!withEmacs) "--without-emacs"
    ++ optional (isNull ruby) "--without-ruby";

  # Notmuch doesn't use autoconf and consequently doesn't tag --bindir and
  # friends
  setOutputFlags = false;
  enableParallelBuilding = true;
  makeFlags = [ "V=1" ];


  outputs = [ "out" "man" "info" ];

  preCheck = let
    test-database = fetchurl {
      url = "https://notmuchmail.org/releases/test-databases/database-v1.tar.xz";
      sha256 = "1lk91s00y4qy4pjh8638b5lfkgwyl282g1m27srsf7qfn58y16a2";
    };
  in ''
    ln -s ${test-database} test/test-databases/database-v1.tar.xz
  '';
  doCheck = !stdenv.hostPlatform.isDarwin && (versionAtLeast gmime.version "3.0.3");
  checkTarget = "test";
  checkInputs = [
    which dtach openssl bash
    gdb man emacs
  ];

  installTargets = [ "install" "install-man" "install-info" ];

  dontGzipMan = true; # already compressed

  meta = {
    description = "Mail indexer";
    homepage    = https://notmuchmail.org/;
    license     = licenses.gpl3;
    maintainers = with maintainers; [ flokli puckipedia the-kenny ];
    platforms   = platforms.unix;
  };
}
