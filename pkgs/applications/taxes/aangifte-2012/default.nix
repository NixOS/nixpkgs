{ stdenv, fetchurl, makeWrapper, xdg_utils, libX11, libXext, libSM }:

stdenv.mkDerivation {
  name = "aangifte2012-1";

  src = fetchurl {
    url = http://download.belastingdienst.nl/belastingdienst/apps/linux/ib2012_linux.tar.gz;
    sha256 = "05bahvk514lncgfr9kybcafahyz1rgfpwp5cykchxbbc033zm0xy";
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
      wrapProgram $out/bin/ib2012ux --prefix PATH : ${xdg_utils}/bin \
                                    --prefix LD_PRELOAD : $(cat $NIX_CC/nix-support/orig-cc)/lib/libgcc_s.so.1
    '';

  meta = {
    description = "Elektronische aangifte IB 2012 (Dutch Tax Return Program)";
    homepage = http://www.belastingdienst.nl/particulier/aangifte2012/download/;
    license = stdenv.lib.licenses.unfree;
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
