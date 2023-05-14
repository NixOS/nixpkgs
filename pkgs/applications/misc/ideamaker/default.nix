{ stdenv
, autoPatchelfHook
, curl
, dpkg
, fetchurl
, gcc
, lib
, libGLU
, libcork
, makeDesktopItem
, qt5
, quazip
, zlib
}:
stdenv.mkDerivation rec {
  pname = "ideamaker";
  version = "4.0.1";

  src = fetchurl {
    # N.B. Unfortunately ideamaker adds a number after the patch number in
    # their release scheme which is not referenced anywhere other than in
    # the download URL. Because of this, I have chosen to not use ${version}
    # and just handwrite the correct values in the following URL, hopefully
    # avoiding surprises for the next person that comes to update this
    # package.
    url = "https://download.raise3d.com/ideamaker/release/4.0.1/ideaMaker_4.0.1.4802-ubuntu_amd64.deb";
    sha256 = "0a1jcakdglcr4kz0kyq692dbjk6aq2yqcp3i6gzni91k791h49hp";
  };

  nativeBuildInputs = [ autoPatchelfHook dpkg qt5.wrapQtAppsHook ];
  buildInputs = [
    curl
    gcc.cc.lib
    libGLU
    libcork
    qt5.qtbase
    qt5.qtserialport
    quazip
    zlib
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,share/pixmaps}

    cp usr/lib/x86_64-linux-gnu/ideamaker/ideamaker $out/bin
    ln -s "${desktopItem}/share/applications" $out/share/
    cp usr/share/ideamaker/icons/ideamaker-icon.png $out/share/pixmaps/${pname}.png

    runHook postInstall
  '';

  desktopItem = makeDesktopItem {
    name = pname;
    exec = pname;
    icon = pname;
    desktopName = "Ideamaker";
    genericName = meta.description;
    categories = [ "Utility" "Viewer" "Engineering" ];
    mimeTypes = [ "application/sla" ];
  };

  meta = with lib; {
    homepage = "https://www.raise3d.com/ideamaker/";
    description = "Raise3D's 3D slicer software";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ lovesegfault ];
    broken = true;  # Segfaults on startup.
  };
}
