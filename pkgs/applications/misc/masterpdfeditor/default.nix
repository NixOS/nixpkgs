{ stdenv, fetchurl, glibc, sane-backends, qtbase, qtsvg, libXext, libX11, libXdmcp, libXau, libxcb }:
  let
    version = "4.2.70";
  in
    stdenv.mkDerivation {
      name = "masterpdfeditor-${version}";
      src = fetchurl {
        url = "http://get.code-industry.net/public/master-pdf-editor-${version}_qt5.amd64.tar.gz";
        sha256 = "0vl5gc1fzsmzl56vd9g3av48557if8a04vhhl5yna8by26h6xz0c";
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
        mkdir -pv $out/bin
        cp -v masterpdfeditor4 $out/bin/masterpdfeditor4
        cp -v masterpdfeditor4.png $out/bin/masterpdfeditor4.png
        cp -v -r stamps $out/bin/stamps
        cp -v -r templates $out/bin/templates
        cp -v -r lang $out/bin/lang
        cp -v -r fonts $out/bin/fonts
        patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
                 --set-rpath $libPath \
                 $out/bin/masterpdfeditor4
      '';
      meta = with stdenv.lib; {
        description = "PDF Editor";
        homepage = "https://code-industry.net/free-pdf-editor/";
        license = licenses.unfreeRedistributable;
        platforms = platforms.linux;
        maintainers = maintainers.cmcdragonkai;
      };
    }
