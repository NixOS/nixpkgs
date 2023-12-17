{ stdenv
, lib
, fetchurl
, dpkg
, autoPatchelfHook
, pango
, gtk3
, alsa-lib
, nss
, libXdamage
, libdrm
, mesa
, libxshmfence
, makeWrapper
, wrapGAppsHook
, gcc-unwrapped
, udev
}:

stdenv.mkDerivation rec {
  pname = "bluemail";
  version = "1.136.21-1884";

  # Taking a snapshot of the DEB release because there are no tagged version releases.
  # For new versions, download the upstream release, extract it and check for the version string.
  # In case there's a new version, create a snapshot of it on https://archive.org before updating it here.
  src = fetchurl {
    url = "https://archive.org/download/blue-mail-1.136.21-1884/BlueMail.deb";
    hash = "sha256-L9mCUjsEcalVxzl80P3QzVclCKa75So2sBG7KjjBVIc=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    dpkg
    wrapGAppsHook
  ];

  buildInputs = [
    pango
    gtk3
    alsa-lib
    nss
    libXdamage
    libdrm
    mesa
    libxshmfence
    udev
  ];

  unpackCmd = "${dpkg}/bin/dpkg-deb -x $src debcontents";

  dontBuild = true;
  dontStrip = true;
  dontWrapGApps = true;

  installPhase = ''
    mkdir -p $out/bin
    mv opt/BlueMail/* $out
    ln -s $out/bluemail $out/bin/bluemail
  '';

  makeWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ gcc-unwrapped.lib gtk3 udev ]}"
    "--prefix PATH : ${lib.makeBinPath [ stdenv.cc ]}"
  ];

  preFixup = ''
    wrapProgram $out/bin/bluemail \
      ''${makeWrapperArgs[@]} \
      ''${gappsWrapperArgs[@]}
  '';

  meta = with lib; {
    description = "Free, secure, universal email app, capable of managing an unlimited number of mail accounts";
    homepage = "https://bluemail.me";
    license = licenses.unfree;
    platforms = platforms.linux;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ onny ];
  };
}
