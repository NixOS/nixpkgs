{ lib
, stdenv
, fetchFromGitHub
, makeBinaryWrapper
, substituteAll
, age
, getopt
, coreutils
, findutils
, gnugrep
, gnused
, qrencode ? null
, wl-clipboard ? null
, git ? null
, xclip ? null
# Used to pretty-print list of all stored passwords, but is not needed to fetch
# or store password by its name. Most users would want this dependency.
, tree ? null
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "passage";
  version = "1.7.4a2";

  src = fetchFromGitHub {
    owner = "FiloSottile";
    repo = "passage";
    rev = "${finalAttrs.version}";
    hash = "sha256-tGHJFzDc2K117r5EMFdKsfw/+EpdZ0qzaExt+RGI4qo=";
  };

  patches = [
    (substituteAll {
      src = ./darwin-getopt-path.patch;
      inherit getopt;
    })
  ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  extraPath = lib.makeBinPath [
    age
    coreutils
    findutils
    git
    gnugrep
    gnused
    qrencode
    tree
    wl-clipboard
    xclip
  ];

  # Using $0 is bad, it causes --help to mention ".passage-wrapped".
  postInstall = ''
    substituteInPlace $out/bin/passage --replace 'PROGRAM="''${0##*/}"' 'PROGRAM=passage'
    wrapProgram $out/bin/passage --prefix PATH : $extraPath --argv0 $pname
  '';

  installFlags = [ "PREFIX=$(out)" "WITH_ALLCOMP=yes" ];

  meta = with lib; {
    description = "Stores, retrieves, generates, and synchronizes passwords securely";
    homepage    = "https://github.com/FiloSottile/passage";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ kaction ma27 ];
    platforms   = platforms.unix;
    mainProgram = "passage";

    longDescription = ''
      passage is a fork of password-store (https://www.passwordstore.org) that uses
      age (https://age-encryption.org) as a backend instead of GnuPG.

      It keeps passwords inside age(1) encrypted files inside a simple
      directory tree and provides a series of commands for manipulating the
      password store, allowing the user to add, remove, edit and synchronize
      passwords.
    '';
  };
})
