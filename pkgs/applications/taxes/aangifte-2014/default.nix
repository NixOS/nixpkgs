{ stdenv, fetchurl, makeWrapper, xdg_utils, libX11, libXext, libSM }:

stdenv.mkDerivation {
  name = "aangifte2014-1";

  src = fetchurl {
    url = http://download.belastingdienst.nl/belastingdienst/apps/linux/ib2014_linux.tar.gz;
    sha256 = "1lkpfn9ban122hw27vvscdlg3933i2lqcdhp7lk26f894jbwzq3j";
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
      wrapProgram $out/bin/ib2014ux --prefix PATH : ${xdg_utils}/bin \
                                    --prefix LD_PRELOAD : $(cat $NIX_CC/nix-support/orig-cc)/lib/libgcc_s.so.1
    '';

  meta = {
    description = "Elektronische aangifte IB 2014 (Dutch Tax Return Program)";
    homepage = http://www.belastingdienst.nl/wps/wcm/connect/bldcontentnl/themaoverstijgend/programmas_en_formulieren/aangifteprogramma_2014_linux;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
