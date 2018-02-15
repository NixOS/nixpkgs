{ stdenv, lib, fetchurl, pkgconfig, zathura_core, girara, poppler }:

stdenv.mkDerivation rec {
  version = "0.2.8";
  name = "zathura-pdf-poppler-${version}";

  src = fetchurl {
    url = "http://pwmt.org/projects/zathura/plugins/download/${name}.tar.gz";
    sha256 = "1m55m7s7f8ng8a7lmcw9z4n5zv7xk4vp9n6fp9j84z6rk2imf7a2";
  };

  nativeBuildInputs = [ pkgconfig zathura_core ];
  buildInputs = [ poppler girara ];

  makeFlags = [ "PREFIX=$(out)" "PLUGINDIR=$(out)/lib" ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    string1='-shared ''${LDFLAGS} -o $@ ''$(OBJECTS) ''${LIBS}'
    string2='-Wl,-dylib_install_name,''${PLUGIN}.dylib -Wl,-bundle_loader,${zathura_core}/bin/.zathura-wrapped -bundle ''${LDFLAGS} -o $@ ''${OBJECTS} ''${LIBS}'
    makefileC1=$(sed -r 's/\.so/.dylib/g' Makefile)
    echo "''${makefileC1/$string1/$string2}" > Makefile
  '';

  meta = with lib; {
    homepage = http://pwmt.org/projects/zathura/;
    description = "A zathura PDF plugin (poppler)";
    longDescription = ''
      The zathura-pdf-poppler plugin adds PDF support to zathura by
      using the poppler rendering library.
    '';
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ cstrahan garbas ];
  };
}
