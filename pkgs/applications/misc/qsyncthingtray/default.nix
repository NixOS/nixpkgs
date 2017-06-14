{ stdenv, lib, fetchFromGitHub, procps ? null
, qtbase, qtwebengine, qtwebkit
, cmake, makeQtWrapper
, syncthing, syncthing-inotify ? null
, preferQWebView ? false }:

stdenv.mkDerivation rec {
  version = "0.5.7";
  name = "qsyncthingtray-${version}";

  src = fetchFromGitHub {
    owner  = "sieren";
    repo   = "QSyncthingTray";
    rev    = "${version}";
    sha256 = "0crrdpdmlc4ahkvp5znzc4zhfwsdih655q1kfjf0g231mmynxhvq";
  };

  buildInputs = [ qtbase qtwebengine ] ++ lib.optional preferQWebView qtwebkit;
  nativeBuildInputs = [ cmake makeQtWrapper ];
  enableParallelBuilding = true;

  cmakeFlags = lib.optional preferQWebView "-DQST_BUILD_WEBKIT=1";

  postPatch = ''
    ${lib.optionalString stdenv.isLinux ''
      substituteInPlace includes/platforms/linux/posixUtils.hpp \
        --replace '"/usr/local/bin/syncthing"'         '"${syncthing}/bin/syncthing"' \
        --replace '"/usr/local/bin/syncthing-inotify"' '"${syncthing-inotify}/bin/syncthing-inotify"' \
        --replace '"pgrep -x'                          '"${procps}/bin/pgrep -x'
    ''}

    ${lib.optionalString stdenv.isDarwin ''
      substituteInPlace includes/platforms/darwin/macUtils.hpp \
        --replace '"/usr/local/bin/syncthing"'         '"${syncthing}/bin/syncthing"'
    ''}
  '';

  installPhase = let qst = "qsyncthingtray"; in ''
    runHook preInstall

    mkdir -p $out/bin
    install -m755 QSyncthingTray $out/bin/${qst}
    ln -s $out/bin/${qst} $out/bin/QSyncthingTray
    wrapQtProgram $out/bin/qsyncthingtray

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/sieren/QSyncthingTray/;
    description = "A Traybar Application for Syncthing written in C++";
    longDescription = ''
        A cross-platform status bar for Syncthing.
        Currently supports OS X, Windows and Linux.
        Written in C++ with Qt.
    '';
    license = licenses.lgpl3;
    maintainers = with maintainers; [ zraexy peterhoeg ];
    platforms = platforms.all;
    # 0.5.7 segfaults when opening the main panel with qt 5.7 and fails to compile with qt 5.8
    broken = builtins.compareVersions qtbase.version "5.7.0" >= 0;
  };
}
