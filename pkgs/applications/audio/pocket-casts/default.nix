{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper, electron
, alsa-lib, gtk3, libXScrnSaver, libXtst, mesa, nss }:

stdenv.mkDerivation rec {
  pname = "pocket-casts";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/felicianotech/pocket-casts-desktop-app/releases/download/v${version}/${pname}_${version}_amd64.deb";
    sha256 = "sha256-nHdF9RDOkM9HwwmK/axiIPM4nmKrWp/FHNC/EI1vTTc=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [ alsa-lib gtk3 libXScrnSaver libXtst mesa nss ];

  unpackCmd = ''
    # If unpacking using -x option, there is a permission error
    dpkg-deb --fsys-tarfile $src | tar -x --no-same-permissions --no-same-owner;
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mv bin $out
    mv lib $out
    mv share $out

    cp $out/lib/pocket-casts/resources/app/icon.png $out/share/pixmaps/pocket-casts.png

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/pocket-casts.desktop \
      --replace Name=pocket-casts "Name=Pocket Casts" \
      --replace GenericName=pocket-casts "GenericName=Podcasts App" \
      --replace Exec=pocket-casts Exec=$out/bin/pocket-casts
    makeWrapper ${electron}/bin/electron \
      $out/bin/pocket-casts \
      --add-flags $out/lib/pocket-casts/resources/app/main.js
  '';

  meta = with lib; {
    description = "Pocket Casts webapp, packaged for the Linux Desktop";
    homepage = "https://github.com/felicianotech/pocket-casts-desktop-app";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.mit;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
