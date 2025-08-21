{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, boost
, libevent
, db48
, autoSignDarwinBinariesHook,
, sqlite
, zeromq
, zlib
, miniupnpc
, qtbase ? null
, qttools ? null
, wrapQtAppsHook ? null
, protobuf
, qrencode
, python3
, gmp
, libbacktrace
, copyDesktopItems
, makeDesktopItem
, util-linux
, gitUpdater
, withGui ? true
, withWallet ? true
}:

stdenv.mkDerivation rec {
  pname = "dashcore";
  version = "22.1.3";

  src = fetchFromGitHub {
    owner = "dashpay";
    repo = "dash";
    rev = "v${version}";
    sha256 = "15chd802km38jv1g4pdbqvydynqc6iqig3d8bxfmazaxjbkcrfgb";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    python3
    util-linux
  ] 
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
    autoSignDarwinBinariesHook
    ]
    ++ lib.optionals withGui [
    wrapQtAppsHook
    copyDesktopItems
    qttools
  ];

  buildInputs = [
    boost
    libevent
    zlib
    miniupnpc
    protobuf
    gmp
    libbacktrace
  ] ++ lib.optionals withWallet [
    db48
    sqlite
  ] ++ lib.optionals withGui [
    qtbase
    qttools
    qrencode
  ];

  preConfigure = lib.optionalString withGui ''
    export LRELEASE="${qttools.dev}/bin/lrelease"
  '';

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
    "--disable-bench"
  ] ++ lib.optionals (!withWallet) [
    "--disable-wallet"
  ] ++ lib.optionals (!withGui) [
    "--without-gui"
  ];

  enableParallelBuilding = true;
  
  # Qt tests require a display and fail in sandboxed builds
  doCheck = !withGui;

  postInstall = lib.optionalString withGui ''
    mkdir -p $out/share/pixmaps
    cp share/pixmaps/dash128.png $out/share/pixmaps/dash.png
  '';

  desktopItems = lib.optionals withGui [
    (makeDesktopItem {
      name = "dash-qt";
      exec = "dash-qt %u";
      icon = "dash";
      desktopName = "Dash Core";
      genericName = "Dash Core QT";
      comment = "Dash Core QT - Digital Cash";
      categories = [ "Finance" "Network" ];
      mimeTypes = [ "x-scheme-handler/dash" ];
    })
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Dash Core - Digital Cash cryptocurrency wallet and node";
    longDescription = ''
      Dash is an open source peer-to-peer cryptocurrency with a strong focus on the
      payments industry. Dash offers a form of money that is portable, inexpensive,
      divisible and fast. It can be spent securely both online and in person with only
      minimal transaction fees.
    '';
    homepage = "https://www.dash.org/";
    changelog = "https://github.com/dashpay/dash/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ktechmidas ];
    platforms = platforms.unix;
    mainProgram = if withGui then "dash-qt" else "dashd";
  };
}
