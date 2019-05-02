{ stdenv, fetchurl, sane-backends, qtbase, qtsvg, nss, autoPatchelfHook, lib, makeWrapper }:

let
  version = "5.4.10";

in stdenv.mkDerivation {
  name = "masterpdfeditor-${version}";

  src = fetchurl {
    url = "https://code-industry.net/public/master-pdf-editor-${version}_qt5.amd64.tar.gz";
    sha256 = "1902ahb2g9xanrip1n0ihr31az8sv9fsvzddnzf70kbwlfclnqf7";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [ nss qtbase qtsvg sane-backends stdenv.cc.cc ];

  dontStrip = true;

  # Please remove this when #44047 is fixed
  postInstall = ''
    wrapProgram $out/bin/masterpdfeditor5 --prefix QT_PLUGIN_PATH : ${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  installPhase = ''
    runHook preInstall

    p=$out/opt/masterpdfeditor
    mkdir -p $out/bin

    substituteInPlace masterpdfeditor5.desktop \
      --replace 'Exec=/opt/master-pdf-editor-5' "Exec=$out/bin" \
      --replace 'Path=/opt/master-pdf-editor-5' "Path=$out/bin" \
      --replace 'Icon=/opt/master-pdf-editor-5' "Icon=$out/share/pixmaps"

    install -Dm644 -t $out/share/pixmaps      masterpdfeditor5.png
    install -Dm644 -t $out/share/applications masterpdfeditor5.desktop
    install -Dm755 -t $p                      masterpdfeditor5
    install -Dm644 license.txt $out/share/$name/LICENSE
    ln -s $p/masterpdfeditor5 $out/bin/masterpdfeditor5
    cp -v -r stamps templates lang fonts $p

    runHook postInstall
  '';

  meta = with stdenv.lib; {
    description = "Master PDF Editor";
    homepage = "https://code-industry.net/free-pdf-editor/";
    license = licenses.unfreeRedistributable;
    platforms = with platforms; [ "x86_64-linux" ];
    maintainers = with maintainers; [ cmcdragonkai flokli ];
  };
}
