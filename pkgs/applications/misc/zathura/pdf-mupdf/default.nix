{ stdenv, lib, fetchurl, pkgconfig, zathura_core, gtk,
gtk-mac-integration, girara, mupdf, openssl , libjpeg, jbig2dec,
openjpeg, fetchpatch }:

stdenv.mkDerivation rec {
  version = "0.3.2";
  name = "zathura-pdf-mupdf-${version}";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura-pdf-mupdf/download/${name}.tar.gz";
    sha256 = "0xkajc3is7ncmb2fmymbzfgrran2bz12i7zsm1vvxhxds728h7ck";
  };

  nativeBuildInputs = [ pkgconfig ];

  buildInputs = [
    zathura_core gtk girara openssl mupdf libjpeg jbig2dec openjpeg
  ] ++ stdenv.lib.optional stdenv.isDarwin [
    gtk-mac-integration
  ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    string1='-shared ''${LDFLAGS} -o $@ ''$(OBJECTS) ''${LIBS}'
    string2='-Wl,-dylib_install_name,''${PLUGIN}.dylib -Wl,-bundle_loader,${zathura_core}/bin/.zathura-wrapped -bundle ''${LDFLAGS} -o $@ ''${OBJECTS} ''${LIBS}'
    makefileC1=$(sed -r 's/\.so/.dylib/g' Makefile)
    echo "''${makefileC1/$string1/$string2}" > Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" "PLUGINDIR=$(out)/lib" ];

  meta = with lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PDF plugin (mupdf)";
    longDescription = ''
      The zathura-pdf-mupdf plugin adds PDF support to zathura by
      using the mupdf rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan ];
  };
}
