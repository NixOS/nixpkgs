{
  stdenv,
  lib,
  fetchgit,
  qt5,
  qtbase,
  qtx11extras,
  qttools,
  zlib,
  gnumake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "x2gokdriveclient";
  version = "0.0.0.1-unstable-2024-09-10";

  src = fetchgit {
    #url = "https://code.x2go.org/git/x2gokdriveclient.git";

    # in reference to https://github.com/NixOS/nixpkgs/tree/master/pkgs#sources
    # I am aware that this is bad practice. The HTTPS url above responds with a 500 and is hopelessly
    # overloaded. the X2Go project doesn't seem to maintain a good and healthy code repository on github
    # either.
    url = "git://code.x2go.org/x2gokdriveclient.git";
    rev = "ed53784a236ef4fe00adce726be492c4bf227d73";
    hash = "sha256-hWPM0bye4I34T7y2ipZOULY2+ehVanmTj4V80+lc+iw=";
  };

  buildInputs = [
    qtbase
    qtx11extras
    qttools
    zlib
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
  ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail "SHELL=/bin/bash" "SHELL=$SHELL" \
      --replace-fail "MAKEOVERRIDES" "NOMAKEOVERRIDES " \
      --replace-fail ".MAKEFLAGS" ".NOFLAGS " \
      --replace-fail "qmake" "${qtbase.dev}/bin/qmake" \
      --replace-fail "-o root -g root" ""
    substituteInPlace \
      VERSION.x2gokdriveclient \
      x2gokdriveclient.spec \
      man/man1/x2gokdriveclient.1 \
      --replace-fail "0.0.0.2" "${finalAttrs.version}"
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "ETCDIR=$(out)/etc"
    "build_client"
    "build_man"
  ];

  installTargets = [
    "install_client"
    "install_man"
  ];

  qtWrapperArgs = [
    "--set QT_QPA_PLATFORM xcb"
  ];

  meta = with lib; {
    description = "Graphical NoMachine NX3 remote desktop client (KDrive client)";
    mainProgram = "x2gokdriveclient";
    homepage = "https://x2go.org/";
    maintainers = with maintainers; [ juliabru ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
})
