{
  stdenv,
  lib,
  fetchurl,
  cups,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rastertoezpl";
  version = "1.1.12";

  src = fetchurl {
    url = "https://godex.s3-accelerate.amazonaws.com/tWHDYruxWFM98frjWNTE,g.file?v01";
    name = "${finalAttrs.pname}-${finalAttrs.version}-source.tar.gz";
    hash = "sha256-iBhM8Mht/XncWU75cd485WK5GZtJNv78yMsFsD0eKWQ=";
  };

  buildInputs = [ cups ];

  configureFlags = [
    "--datarootdir=${placeholder "out"}/share"
    "PPDDIR=${placeholder "out"}/share/cups/model"
  ];

  postInstall = ''
    mkdir -p $out/lib/cups/filter
    ln -s $out/libexec/rastertoezpl/rastertoezpl $out/lib/cups/filter/rastertoezpl
    gzip -9n $out/share/cups/model/godex/*.ppd
  '';

  meta = {
    description = "CUPS driver for GODEX printers";
    homepage = "https://www.godexintl.com/downloads";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ stargate01 ];
    platforms = lib.platforms.linux;
  };
})
