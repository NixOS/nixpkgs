{ lib, stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper,
  atk, ffmpeg, gdk-pixbuf, gtk3, libXtst }:

stdenv.mkDerivation rec {
  pname = "signumone-ks";
  version = "3.1.3";

  src = fetchurl {
    url = "https://cdn-dist.signum.one/${version}/${pname}-${version}.deb";
    sha256 = "00wlya3kb6qac2crflm86km9r48r29bvngjq1wgzj9w2xv0q32b9";
  };

  # Necessary to avoid using multiple ffmpeg and gtk libs
  autoPatchelfIgnoreMissingDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    atk gdk-pixbuf ffmpeg
    gtk3 libXtst
  ];

  libPath = lib.makeLibraryPath buildInputs;

  unpackPhase = ''
    dpkg-deb -x ${src} ./
  '';

  installPhase = ''
    DESKTOP_PATH=$out/share/applications/signumone-ks.desktop

    mkdir -p $out/bin $out/share/applications
    mv opt/SignumOne-KS/SignumOne-KS.desktop $DESKTOP_PATH
    mv opt $out

    substituteInPlace $DESKTOP_PATH --replace 'Exec=/opt/SignumOne-KS' Exec=$out/bin
    substituteInPlace $DESKTOP_PATH --replace 'Icon=' Icon=$out

    makeWrapper $out/opt/SignumOne-KS/SignumOne-KS \
      $out/bin/SignumOne-KS \
      --prefix LD_LIBRARY_PATH : ${libPath}
  '';

  meta = with lib; {
    description = "Digital signature tool for Costa Rican electronic invoicing";
    homepage = "https://signum.one/download.html";
    sourceProvenance = with sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
