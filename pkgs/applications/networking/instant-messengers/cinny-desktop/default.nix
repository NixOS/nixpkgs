{ stdenv
, lib
, dpkg
, fetchurl
, autoPatchelfHook
, glib-networking
, openssl
, webkitgtk
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "cinny-desktop";
  version = "2.2.4";

  src = fetchurl {
    url = "https://github.com/cinnyapp/cinny-desktop/releases/download/v${version}/Cinny_desktop-x86_64.deb";
    sha256 = "sha256-ibUXNGgc23ndTqQKD0np5EH1T3xipVAmETbIy7akqkg=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = [
    glib-networking
    openssl
    webkitgtk
    wrapGAppsHook
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = "mv usr $out";

  meta = with lib; {
    description = "Yet another matrix client for desktop";
    homepage = "https://github.com/cinnyapp/cinny-desktop";
    maintainers = [ maintainers.aveltras ];
    license = licenses.mit;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
    mainProgram = "cinny";
  };
}
