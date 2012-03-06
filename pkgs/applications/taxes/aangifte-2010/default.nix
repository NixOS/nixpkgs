{ stdenv, fetchurl, makeWrapper, xdg_utils, libX11, libXext, libSM }:

stdenv.mkDerivation {
  name = "aangifte2010-1";
  
  src = fetchurl {
    url = http://download.belastingdienst.nl/belastingdienst/apps/linux/ib2010_linux.tar.gz;
    sha256 = "15mingjyqjvy4k6ws6qlhaaw8dj7336b54zg7mj70ig7jskjkz5h";
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
      wrapProgram $out/bin/ib2010ux --prefix PATH : ${xdg_utils}/bin
    '';

  meta = {
    description = "Elektronische aangifte IB 2010 (Dutch Tax Return Program)";
    url = http://www.belastingdienst.nl/particulier/aangifte2009/download/;
  };
}
