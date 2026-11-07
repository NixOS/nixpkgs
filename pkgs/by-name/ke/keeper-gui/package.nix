{
  stdenv,
  fetchzip,
  lib,
  dpkg,
  autoPatchelfHook,
  libsecret,
  nss,
  gtk3,
  alsa-lib,
  pcsclite,
  libgbm,
  libnotify,
  libdrm,
  gvfs,
}:
let
  pname = "keeperpasswordmanager";
  version = "18.5.1";
in
stdenv.mkDerivation rec {
  inherit pname version;
  strictDeps = true;
  __structuredAttrs = true;

  # Only .deb and .rpm are provided (no .zip or .tgz/tar.gz). We use the deb here.
  src = fetchzip {
    url = "https://www.keepersecurity.com/desktop_electron/Linux/repo/deb/${pname}_${version}_amd64.deb";
    hash = "sha256-SMfWVprOBTrandksQ7tjLTYbwOP6ZNZuhzhUqABKQf4=";
    nativeBuildInputs = [ dpkg ];
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    libsecret
    gtk3
    nss
    libgbm
    alsa-lib
    pcsclite
    libnotify
    libdrm
    gvfs
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cp -R usr/share usr/lib $out/
    # fix the path in the desktop file
    substituteInPlace \
      $out/share/applications/keeperpasswordmanager.desktop \
      --replace /lib/ $out/lib/
    ln -s $out/lib/keeperpasswordmanager/keeperpasswordmanager  $out/bin/keeperpasswordmanager
    runHook postInstall
  '';

  meta = with lib; {
    description = "Password manager with enteprise features";
    # Yoinked from the .deb
    longDescription = "Keeper is the world's #1 most downloaded password keeper and secure digital vault for protecting and managing your passwords and other secret information. Millions of people use Keeper to protect their most sensitive and private information.";
    homepage = "https://www.keepersecurity.com/";
    platforms = platforms.linux;
    license = licenses.unfree;
    maintainers = with maintainers; [
      TheToddLuci0
    ];
    mainProgram = "keeperpasswordmanager";
    sourceProvenance = [ sourceTypes.binaryNativeCode ];
    downloadPage = "https://www.keepersecurity.com/download.html";
  };

}
