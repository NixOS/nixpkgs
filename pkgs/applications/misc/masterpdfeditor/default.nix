{ stdenv, fetchurl, sane-backends, qtbase, qtsvg, nss, autoPatchelfHook }:
let
  version = "5.1.00";
in stdenv.mkDerivation {
  name = "masterpdfeditor-${version}";
  src = fetchurl {
    url = "https://code-industry.net/public/master-pdf-editor-${version}_qt5.amd64.tar.gz";
    sha256 = "1s2zhx9xr1ny5s8hmlb99v3z1v26vmx87iixk8cdgndz046p9bg9";
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  buildInputs = [ nss qtbase qtsvg sane-backends stdenv.cc.cc ];

  dontStrip = true;

  installPhase = ''
   p=$out/opt/masterpdfeditor
   mkdir -p $out/bin $p $out/share/applications $out/share/pixmaps

   substituteInPlace masterpdfeditor5.desktop \
     --replace 'Exec=/opt/master-pdf-editor-5' "Exec=$out/bin" \
     --replace 'Path=/opt/master-pdf-editor-5' "Path=$out/bin" \
     --replace 'Icon=/opt/master-pdf-editor-5' "Icon=$out/share/pixmaps"
   cp -v masterpdfeditor5.png $out/share/pixmaps/
   cp -v masterpdfeditor5.desktop $out/share/applications

   cp -v masterpdfeditor5 $p/
   ln -s $p/masterpdfeditor5 $out/bin/masterpdfeditor5
   cp -v -r stamps templates lang fonts $p

   install -D license.txt $out/share/$name/LICENSE
  '';

  meta = with stdenv.lib; {
    description = "Master PDF Editor";
    homepage = "https://code-industry.net/free-pdf-editor/";
    license = licenses.unfreeRedistributable;
    platforms = with platforms; [ "x86_64-linux" ];
    maintainers = with maintainers; [ cmcdragonkai flokli ];
  };
}
