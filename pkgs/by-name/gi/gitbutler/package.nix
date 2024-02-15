{ stdenv
, lib
, fetchurl
, wrapGAppsHook
, dpkg
, autoPatchelfHook
, zlib
, webkitgtk
, gtk3
, cairo
, gdk-pixbuf
, libsoup
, glib
, libappindicator
, libayatana-appindicator
}:
let
  version = "0.10.6";
  build = "619";
in
stdenv.mkDerivation {
  pname = "gitbutler";
  inherit version;

  src = fetchurl {
    url = "https://releases.gitbutler.com/releases/release/${version}-${build}/linux/x86_64/git-butler_${version}_amd64.deb";
    hash = "sha256-3Nq1QVCHeP8RKaG0PFojtBXIBm+eRKlqqjc65HPWzGY=";
  };

  unpackCmd = ''
    dpkg-deb -x $curSrc .
  '';

  dontBuild = true;

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    wrapGAppsHook
  ];

  buildInputs = [
    zlib
    webkitgtk
    gtk3
    cairo
    gdk-pixbuf
    libsoup
    glib
  ];

  runtimeDependencies = [
    libappindicator
    libayatana-appindicator
  ];

  installPhase = ''
    runHook preInstall
    cp  -dr . $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "A Git client for simultaneous branches on top of your existing workflow";
    homepage = "https://gitbutler.com/";
    license = licenses.fsl-10-mit;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ bobvanderlinden ];
    mainProgram = "git-butler";
  };
}
