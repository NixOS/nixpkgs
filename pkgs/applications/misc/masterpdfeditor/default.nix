{ stdenv, fetchurl, glibc, sane-backends, qtbase, qtsvg, libXext, libX11, libXdmcp, libXau, libxcb }:
  let
    version = "4.3.61";
  in
    stdenv.mkDerivation {
      name = "masterpdfeditor-${version}";
      src = fetchurl {
        url = "http://get.code-industry.net/public/master-pdf-editor-${version}_qt5.amd64.tar.gz";
        sha256 = "1g6mx8nch6ypf78h6xsb673wim19wn5ni5840armzg0pvi3sfknm";
      };
      libPath = stdenv.lib.makeLibraryPath [
        stdenv.cc.cc
        glibc
        sane-backends
        qtbase
        qtsvg
        libXext
        libX11
        libXdmcp
        libXau
        libxcb
      ];
      dontStrip = true;
      installPhase = ''
        mkdir -p $out/bin $out/share/applications $out/share/pixmaps

        substituteInPlace masterpdfeditor4.desktop \
          --replace 'Exec=/opt/master-pdf-editor-4' "Exec=$out/bin" \
          --replace 'Path=/opt/master-pdf-editor-4' "Path=$out/bin" \
          --replace 'Icon=/opt/master-pdf-editor-4' "Icon=$out/share/pixmaps"

        cp -v masterpdfeditor4 $out/bin/masterpdfeditor4
        cp -v masterpdfeditor4.png $out/share/pixmaps/
        cp -v masterpdfeditor4.desktop $out/share/applications

        cp -v -r stamps $out/bin/stamps
        cp -v -r templates $out/bin/templates
        cp -v -r lang $out/bin/lang
        cp -v -r fonts $out/bin/fonts
        install -D license.txt $out/share/$name/LICENSE

        patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                 --set-rpath $libPath \
                 $out/bin/masterpdfeditor4
      '';
      meta = with stdenv.lib; {
        description = "Master PDF Editor";
        homepage = "https://code-industry.net/free-pdf-editor/";
        license = licenses.unfreeRedistributable;
        platforms = with platforms; [ "x86_64-linux" ];
        maintainers = with maintainers; [ cmcdragonkai flokli ];
      };
    }
