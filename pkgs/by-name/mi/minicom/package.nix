{
  lib,
  stdenv,
  fetchFromGitLab,
  autoreconfHook,
  makeWrapper,
  pkg-config,
  lrzsz,
  ncurses,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "minicom";
  version = "2.10";

  src = fetchFromGitLab {
    domain = "salsa.debian.org";
    owner = "minicom-team";
    repo = "minicom";
    rev = version;
    sha256 = "sha256-wC6VlMRwuhV1zQ26wNx7gijuze8E2CvnzpqOSIPzq2s=";
  };

  buildInputs = [
    ncurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  nativeBuildInputs = [
    autoreconfHook
    makeWrapper
    pkg-config
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--sysconfdir=/etc"
    "--enable-lock-dir=/var/lock"
  ];

  patches = [ ./xminicom_terminal_paths.patch ];

  preConfigure = ''
    # Have `configure' assume that the lock directory exists.
    substituteInPlace configure \
      --replace 'test -d $UUCPLOCK' true
  '';

  postInstall = ''
    for f in $out/bin/*minicom ; do
      wrapProgram $f \
        --prefix PATH : ${lib.makeBinPath [ lrzsz ]}:$out/bin
    done
  '';

<<<<<<< HEAD
  meta = {
    description = "Modem control and terminal emulation program";
    homepage = "https://salsa.debian.org/minicom-team/minicom";
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "Modem control and terminal emulation program";
    homepage = "https://salsa.debian.org/minicom-team/minicom";
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    longDescription = ''
      Minicom is a menu driven communications program. It emulates ANSI
      and VT102 terminals. It has a dialing directory and auto zmodem
      download.
    '';
<<<<<<< HEAD
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
=======
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
