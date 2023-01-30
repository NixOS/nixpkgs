{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, electron
, alsa-lib, glibc, gtk3, libxshmfence, mesa, nss }:

stdenv.mkDerivation rec {
  pname = "threema-desktop";
  version = "1.2.21";

  src = fetchurl {
    # As Threema only offers a Latest Release url, the plan is to upload each
    # new release url to web.archive.org until their Github releases page gets populated.
    url = "https://web.archive.org/web/20220915175906if_/https://releases.threema.ch/web-electron/v1/release/Threema-Latest.deb";
    sha256 = "0icxn5whsvwmdmfbkfk4xnl3dn4iif5s5yw5hsimmyx066fq0qhb";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ alsa-lib glibc gtk3 libxshmfence mesa nss ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    # Can't unpack with the common dpkg-deb -x method
    dpkg --fsys-tarfile $src | tar --extract
  '';

  installPhase = ''
    runHook preInstall

    # This will cause confusion, not needed
    rm -r usr/bin
    mv usr $out

    runHook postInstall
  '';

  postFixup = ''
    mv $out/share/applications/threema.desktop $out/share/applications/threema-desktop.desktop
    makeWrapper ${electron}/bin/electron $out/bin/threema \
      --add-flags $out/lib/threema/resources/app.asar
  '';

  meta = with lib; {
    description = "Desktop client for Threema, a privacy-focused end-to-end encrypted mobile messenger";
    homepage = "https://threema.ch";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
