{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, libXext
, libxcrypt-legacy
, libSM
, cups
, vte
, kerberos
, lttng-ust_2_12
, webkitgtk
, libsoup
, icu
, openssl
, makeWrapper
, gtk3-x11
,
}:
let
  pname = "remote-desktop-manager";
  version = "2023.3.1.4";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://cdn.devolutions.net/download/Linux/RDM/${version}/RemoteDesktopManager_${version}_amd64.deb";
    sha256 = "sha256-XTPDZP01j8PNmvMqynlRiaXOc0QX+ZSWtehQWc/X70Q=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    libXext
    libxcrypt-legacy
    libSM
    cups
    vte
    kerberos
    lttng-ust_2_12
    webkitgtk
    libsoup
    stdenv.cc.cc.lib
  ];

  unpackPhase = "dpkg-deb -x $src .";

  installPhase = ''
    mkdir $out
    cp -r bin usr $out

    ln -s $out/usr/share $out/share
  '';

  postFixup = ''
    wrapProgram $out/usr/lib/devolutions/RemoteDesktopManager/RemoteDesktopManager \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [icu gtk3-x11 openssl]};

    substituteInPlace $out/bin/remotedesktopmanager $out/share/applications/remotedesktopmanager.desktop \
      --replace /usr/lib $out/usr/lib \
      --replace /usr/share $out/usr/share
  '';

  meta = with lib; {
    homepage = "https://devolutions.net/remote-desktop-manager/";
    description = "Remote Desktop Manager (RDM) centralizes all remote connections on a single platform that is securely shared between users and across the entire team";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "remotedesktopmanager";
    maintainers = with maintainers; [ Dines97 ];
  };
}
