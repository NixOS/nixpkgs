{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, pkg-config
, dpkg
, openssl
, webkitgtk
, libappindicator
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  name = "holochain-launcher";
  version = "0.9.4";

  src = fetchurl {
    url = "https://github.com/holochain/launcher/releases/download/v${version}/holochain-launcher_${version}_amd64.deb";
    sha256 = "sha256-qTzm4pwhYbEN96a/Dz/JcJcZ2OobyQJRNC2yH4CbhzQ=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    wrapGAppsHook # required for FileChooser
  ];

  buildInputs = [
    openssl
    webkitgtk
    libappindicator
  ];

  unpackCmd = "dpkg-deb -x $curSrc source";

  installPhase = ''
    mv usr $out
  '';

  preFixup = ''
    patchelf --add-needed "libappindicator3.so" "$out/bin/holochain-launcher"
  '';

  meta = with lib; {
    description = "A cross-platform executable that launches a local Holochain conductor, and installs and opens apps";
    homepage = "https://github.com/holochain/launcher";
    maintainers = [ maintainers.steveej ];
    license = licenses.cal10;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    platforms = platforms.linux;
  };
}
