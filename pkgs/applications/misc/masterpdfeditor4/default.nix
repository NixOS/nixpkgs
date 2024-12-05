{ stdenv, fetchurl, sane-backends, qtbase, qtsvg, autoPatchelfHook, lib, wrapQtAppsHook }:

stdenv.mkDerivation rec {
  pname = "masterpdfeditor4";
  version = "4.3.89";

  src = fetchurl {
    url = "https://code-industry.net/public/master-pdf-editor-${version}_qt5.amd64.tar.gz";
    sha256 = "0k5bzlhqglskiiq86nmy18mnh5bf2w3mr9cq3pibrwn5pisxnxxc";
  };

  nativeBuildInputs = [ autoPatchelfHook wrapQtAppsHook ];

  buildInputs = [ qtbase qtsvg sane-backends stdenv.cc.cc ];

  installPhase = ''
    runHook preInstall

    app_dir=$out/opt/masterpdfeditor4
    mkdir -p $out/bin

    substituteInPlace masterpdfeditor4.desktop \
      --replace 'Exec=/opt/master-pdf-editor-4' "Exec=$out/bin" \
      --replace 'Path=/opt/master-pdf-editor-4' "Path=$out/bin" \
      --replace 'Icon=/opt/master-pdf-editor-4' "Icon=$out/share/pixmaps"

    install -Dm644 -t $out/share/pixmaps      masterpdfeditor4.png
    install -Dm644 -t $out/share/applications masterpdfeditor4.desktop
    install -Dm755 -t $app_dir                masterpdfeditor4
    install -Dm644 license.txt $out/share/$name/LICENSE
    ln -s $app_dir/masterpdfeditor4 $out/bin/masterpdfeditor4
    cp -v -r stamps templates lang fonts $app_dir

    runHook postInstall
  '';

  meta = with lib; {
    description = "Master PDF Editor - version 4, without watermark";
    homepage = "https://code-industry.net/free-pdf-editor/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfreeRedistributable;
    platforms = [ "x86_64-linux" ];
  };
}
