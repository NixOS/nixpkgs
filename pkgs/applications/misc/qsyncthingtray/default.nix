{ mkDerivation, stdenv, lib, fetchFromGitHub, fetchpatch, procps
, qtbase, qtwebengine, qtwebkit
, cmake
, syncthing
, preferQWebView ? false
, preferNative   ? true }:

mkDerivation rec {
  version = "0.5.8";
  name = "qsyncthingtray-${version}";

  src = fetchFromGitHub {
    owner  = "sieren";
    repo   = "QSyncthingTray";
    rev    = "${version}";
    sha256 = "1n9g4j7qznvg9zl6x163pi9f7wsc3x6q76i33psnm7x2v1i22x5w";
  };

  buildInputs = [ qtbase qtwebengine ] ++ lib.optional preferQWebView qtwebkit;

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ ]
    ++ lib.optional preferQWebView "-DQST_BUILD_WEBKIT=1"
    ++ lib.optional preferNative   "-DQST_BUILD_NATIVEBROWSER=1";

  patches = [ (fetchpatch {
    name = "support_native_browser.patch";
    url = "https://patch-diff.githubusercontent.com/raw/sieren/QSyncthingTray/pull/225.patch";
    sha256 = "0w665xdlsbjxs977pdpzaclxpswf7xys1q3rxriz181lhk2y66yy";
  }) ] ++ lib.optional (!preferQWebView && !preferNative) ./qsyncthingtray-0.5.8-qt-5.6.3.patch;

  postPatch = ''
    ${lib.optionalString stdenv.isLinux ''
      substituteInPlace includes/platforms/linux/posixUtils.hpp \
        --replace '"/usr/local/bin/syncthing"'         '"${syncthing}/bin/syncthing"' \
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

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = https://github.com/sieren/QSyncthingTray/;
    description = "A Traybar Application for Syncthing written in C++";
    longDescription = ''
        A cross-platform status bar for Syncthing.
        Currently supports macOS, Windows and Linux.
        Written in C++ with Qt.
    '';
    license = licenses.lgpl3;
    maintainers = with maintainers; [ zraexy peterhoeg ];
    platforms = platforms.all;
    # 0.5.7 segfaults when opening the main panel with qt 5.7 and fails to compile with qt 5.8
    # but qt > 5.6 works when only using the native browser
    # https://github.com/sieren/QSyncthingTray/issues/223
    broken = (builtins.compareVersions qtbase.version "5.7.0" >= 0 && !preferNative);
  };
}
