{ stdenv, fetchurl, pkgconfig, gtk, zathura_core, girara, djvulibre, gettext }:

stdenv.mkDerivation rec {
  name = "zathura-djvu-0.2.7";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1sbfdsyp50qc85xc4458sn4w1rv1qbygdwmcr5kjlfpsmdq98vhd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ djvulibre gettext zathura_core gtk girara ];

  patches = [ ./gtkflags.patch ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    string1='-shared ''${LDFLAGS} -o $@ ''$(OBJECTS) ''${LIBS}'
    string2='-Wl,-dylib_install_name,''${PLUGIN}.dylib -Wl,-bundle_loader,${zathura_core}/bin/.zathura-wrapped -bundle ''${LDFLAGS} -o $@ ''${OBJECTS} ''${LIBS}'
    makefileC1=$(sed -r 's/\.so/.dylib/g' Makefile)
    echo "''${makefileC1/$string1/$string2}" > Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" "PLUGINDIR=$(out)/lib" ];

  meta = with stdenv.lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura DJVU plugin";
    longDescription = ''
      The zathura-djvu plugin adds DjVu support to zathura by using the
      djvulibre library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ garbas ];
  };
}

