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
              --set-interpreter "$(cat $NIX_GCC/nix-support/dynamic-linker)" \
              --set-rpath ${stdenv.lib.makeLibraryPath [ libX11 libXext libSM ]}:$(cat $NIX_GCC/nix-support/orig-gcc)/lib \
              $i
      done
    '';

  installPhase =
    ''
      mkdir -p $out
      cp -prvd * $out/
      wrapProgram $out/bin/ib2012ux --prefix PATH : ${xdg_utils}/bin
    '';

  meta = {
    description = "Elektronische aangifte IB 2012 (Dutch Tax Return Program)";
    url = http://www.belastingdienst.nl/particulier/aangifte2012/download/;
  };
}
