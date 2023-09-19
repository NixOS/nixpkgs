{ lib
, stdenv
, fetchurl
, dpkg
, autoPatchelfHook
, makeWrapper
, electron
, alsa-lib
, glibc
, gtk3
, libxshmfence
, mesa
, nss
}:

stdenv.mkDerivation {
  pname = "threema-desktop";
  version = "1.2.36";

  src = fetchurl {
    # As Threema only offers a Latest Release url, the plan is to upload each
    # new release url to web.archive.org until their Github releases page gets populated.
    url = "https://web.archive.org/web/20230918134428/https://releases.threema.ch/web-electron/v1/release/Threema-Latest.deb";
    hash = "sha256-CunyfAU33Cq6oCTraS7LigP3ezI+MCSYZEv12tXy/xc=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    glibc
    gtk3
    libxshmfence
    mesa
    nss
  ];

  unpackPhase = ''
    # Can't unpack with the common dpkg-deb -x method
    dpkg --fsys-tarfile $src | tar --extract
  '';

  installPhase = ''
    runHook preInstall

    # This will cause confusion, not needed
    rm -r usr/bin
    mv usr $out
    # https://github.com/NixOS/nixpkgs/issues/254798#issuecomment-1722604390, this is not used
    rm $out/lib/threema/threema-web

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
    mainProgram = "threema";
    platforms = [ "x86_64-linux" ];
  };
}
