{ stdenv, fetchurl, makeWrapper, xdg_utils, libX11, libXext, libSM }:

stdenv.mkDerivation {
  name = "aangifte2009-1";
  
  src = fetchurl {
    url = http://download.belastingdienst.nl/belastingdienst/apps/linux/ib2009_linux.tar.gz;
    sha256 = "07l83cknzxwlzmg1w6baf2wqs06bh8v3949n51hy1p3wgr8hf408";
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
      wrapProgram $out/bin/ib2009ux --prefix PATH : ${xdg_utils}/bin
    '';

  meta = {
    description = "Elektronische aangifte IB 2009 (Dutch Tax Return Program)";
    homepage = http://www.belastingdienst.nl/particulier/aangifte2009/download/;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
