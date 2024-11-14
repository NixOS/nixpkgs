{ lib
, fetchzip
, fetchpatch
, cups
, python3Packages
, patchPpdFilesHook
}:

python3Packages.buildPythonApplication rec {
  pname = "rastertosag-gdi";
  version = "0.1";
  src = fetchzip {
    url = "https://www.openprinting.org/download/printing/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1ldplpv497j8vhw24sksg3fiw8c5pqr0wajajh7p5xpvb6zlcmvw";
  };
  patches = [
    # port to python 3
    ( fetchpatch {
      url = "https://sources.debian.org/data/main/r/${pname}/0.1-7/debian/patches/0001-${pname}-python3.patch";
      sha256 = "1l3xbrs67025595k9ba5794q3s74anizpbxwsshcfhmbrzd9h8hg";
    })
  ];
  format = "other";
  nativeBuildInputs = [ (lib.getBin cups) patchPpdFilesHook ];
  # The source image also brings pre-built ppd files,
  # but we prefer to generate from source where possible, so
  # the following line generates ppd files from the drv file.
  postBuild = ''
    ppdc -v -d . -I "${cups}/share/cups/ppdc" rastertosag-gdi.drv
  '';
  installPhase = ''
    runHook preInstall
    install -vDm 0644 -t "${placeholder "out"}/share/cups/model/rastertosag-gdi/" *.ppd
    install -vDm 0755 -t "${placeholder "out"}/bin/" rastertosag-gdi
    install -vd "${placeholder "out"}/lib/cups/filter/"
    ln -vst "${placeholder "out"}/lib/cups/filter/" "${placeholder "out"}/bin/rastertosag-gdi"
    runHook postInstall
  '';
  ppdFileCommands = [ "rastertosag-gdi" ];
  postFixup = ''
    gzip -9nv "${placeholder "out"}/share/cups/model/rastertosag-gdi"/*.ppd
  '';
  meta = {
    description = "CUPS driver for Ricoh Aficio SP 1000S and SP 1100S printers";
    mainProgram = "rastertosag-gdi";
    downloadPage = "https://www.openprinting.org/download/printing/rastertosag-gdi/";
    homepage = "https://www.openprinting.org/driver/rastertosag-gdi/";
    license = lib.licenses.free;  # just "GPL", according to README
    maintainers = [ lib.maintainers.yarny ];
    longDescription = ''
      This package brings CUPS raster filter
      for Ricoh Aficio SP 1000S and SP 1100S.
      In contrast to other Ricoh laser printers,
      they use the proprietary SAG-GDI raster format by
      Sagem Communication and do not understand PCL or PostScript.
      Therefore they do not work with Ricoh's PPD files.
    '';
  };
}
