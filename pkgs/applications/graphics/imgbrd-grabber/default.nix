{ stdenv
, cmake
, fetchzip
, openssl
, autoPatchelfHook
, makeWrapper
, qtmultimedia
, wrapQtAppsHook
}:
stdenv.mkDerivation rec {
  name = "imgbrd-grabber";
  version = "7.3.2";

  buildInputs = [
    stdenv.cc.cc.lib
    openssl
    qtmultimedia
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    wrapQtAppsHook
  ];

  installPhase = ''
    mkdir -p $out/share/grabber
    cp -R * $out/share/grabber

    mkdir -p $out/bin
    ln -s $out/share/grabber/Grabber /$out/bin/grabber

    mkdir -p $out/share/applications
    mv $out/share/grabber/Grabber.desktop $out/share/applications/

  '';

  src = fetchzip {
    url = "https://github.com/Bionus/imgbrd-grabber/releases/download/v${version}/Grabber_v${version}.tar.gz";
    sha256 = "05isnqhvcp8ycaj8hx6wn0c3la729mb36dzpmlpxfb1p5dj8p49k";
  };

  meta = with stdenv.lib; {
    homepage = "https://github.com/Bionus/imgbrd-grabber";
    description = "Very customizable imageboard/booru downloader with powerful filenaming features.";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ evanjs ];
  };
}
