{ stdenv, fetchurl, dpkg, autoPatchelfHook, makeWrapper,
  atk, ffmpeg, gdk-pixbuf, glibc, gtk3, libav_0_8, libXtst }:

stdenv.mkDerivation rec {
  pname = "signumone-ks";
  version = "3.1.2";

  src = fetchurl {
    url = "https://cdn-dist.signum.one/${version}/${pname}-${version}.deb";
    sha256 = "4efd80e61619ccf26df1292194fcec68eb14d77dfcf0a1a673da4cf5bf41f4b7";
  };

  # Necessary to avoid using multiple ffmpeg and gtk libs
  autoPatchelfIgnoreMissingDeps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    atk glibc gdk-pixbuf stdenv.cc.cc ffmpeg
    libav_0_8 gtk3 libXtst
  ];

  libPath = stdenv.lib.makeLibraryPath buildInputs;

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

  meta = with stdenv.lib; {
    description = "Digital signature tool for Costa Rican electronic invoicing";
    homepage = "https://signum.one/download.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}
