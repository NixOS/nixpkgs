{ lib
, stdenv
, fetchFromGitea
, cmake
, kconf
, lmdb
, qxmpp
, boost
, libomemo-c
, pkg-config
, libsForQt5
, imagemagick

, kwalletSupport ? false # secure password storage
, kioSupport ? false # better show in folder action
, kconfSupport ? false # system themes support
}:

stdenv.mkDerivation rec {
  pname = "squawk-chat";
  version = "0.2.3";

  src = (fetchFromGitea {
    domain = "git.macaw.me";
    owner = "blue";
    repo = "squawk";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-dPeB2DOJ22shgeV6UBXb6Kcswre4q3CRaWogLsLyl2U=";
  }).overrideAttrs (_: {
    GIT_CONFIG_COUNT = 1;
    GIT_CONFIG_KEY_0 = "url.https://git.macaw.me/.insteadOf";
    GIT_CONFIG_VALUE_0 = "gitea@git.macaw.me:";
  });

  nativeBuildInputs = [ cmake boost libomemo-c pkg-config libsForQt5.wrapQtAppsHook imagemagick libsForQt5.kwallet libsForQt5.kio ];
  buildInputs = [ libsForQt5.qt5.qtbase lmdb qxmpp ]
    ++ lib.optionals kwalletSupport [ libsForQt5.kwallet ]
    ++ lib.optionals kioSupport [ libsForQt5.kio ]
    ++ lib.optionals kconfSupport [ kconf ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DSYSTEM_LMDBAL=False"
  ];

  postInstall = ''
    mv $out/bin/squawk $out/bin/squawk-chat
  '';

  meta = with lib; {
    description = "Squawk is a compact XMPP desktop messenger built in Qt";
    homepage = "https://git.macaw.me/blue/squawk";
    license = licenses.gpl3;
    platforms = with platforms; linux;
    maintainers = with maintainers; [ annoyingrains ];
    mainProgram = "squawk-chat";
  };
}
