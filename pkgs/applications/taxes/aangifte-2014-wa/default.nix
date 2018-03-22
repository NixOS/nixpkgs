{ stdenv, fetchurl, makeWrapper, xdg_utils, libX11, libXext, libSM }:

stdenv.mkDerivation {
  name = "aangifte2014-wa";

  src = fetchurl {
    url = http://download.belastingdienst.nl/belastingdienst/apps/linux/wa2014_linux.tar.gz;
    sha256 = "0ckwk190vyvwgv8kq0xxsxvm1kniv3iip4l5aycjx1wcyic2289x";
  };

  dontStrip = true;
  dontPatchELF = true;

  buildInputs = [ makeWrapper ];

  buildPhase =
    ''
      for i in bin/*; do
          patchelf \
              --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
              --set-rpath ${stdenv.lib.makeLibraryPath [ libX11 libXext libSM ]}:$(cat $NIX_CC/nix-support/orig-cc)/lib \
              $i
      done
    '';

  installPhase =
    ''
      mkdir -p $out
      cp -prvd * $out/
      wrapProgram $out/bin/wa2014ux --prefix PATH : ${xdg_utils}/bin \
                                    --prefix LD_PRELOAD : $(cat $NIX_CC/nix-support/orig-cc)/lib/libgcc_s.so.1
    '';

  meta = {
    description = "Elektronische aangifte WA 2014 (Dutch Tax Return Program)";
    homepage = http://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/themaoverstijgend/programmas_en_formulieren/aangifteprogramma_2014_linux;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
