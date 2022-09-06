{ stdenv
, fetchurl
, lib
, autoPatchelfHook
, cups
, dbus
, fontconfig
, gccForLibs
, libX11
, libXcomposite
, libXcursor
, libXdamage
, libXext
, libXi
, libXrandr
, libXrender
, libXtst
, libinput
, libxcb
, libxkbcommon
, nss
, qttools
, qtwebengine
, xcbutilimage
, xcbutilkeysyms
, xcbutilrenderutil
, xcbutilwm
}:

stdenv.mkDerivation {
  pname = "p4v";
  version = "2022.2.2336701";

  src = fetchurl {
    url = "https://web.archive.org/web/20220902181457/https://ftp.perforce.com/perforce/r22.2/bin.linux26x86_64/p4v.tgz";
    sha256 = "8fdade4aafe25f568a61cfd80823aa90599c2a404b7c6b4a0862c84b07a9f8d2";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    cups
    dbus
    fontconfig
    gccForLibs
    libX11
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXi
    libXrandr
    libXrender
    libXtst
    libinput
    libxcb
    libxkbcommon
    nss
    qttools
    qtwebengine
    xcbutilimage
    xcbutilkeysyms
    xcbutilrenderutil
    xcbutilwm
  ];

  dontBuild = true;

  # Don't wrap the Qt apps; upstream has its own wrapper scripts.
  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out
    cp -r bin lib $out
    addAutoPatchelfSearchPath $out/lib
  '';

  meta = {
    description = "Perforce Helix Visual Client";
    homepage = "https://www.perforce.com";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ impl nathyong nioncode ];
  };
}
