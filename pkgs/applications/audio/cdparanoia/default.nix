{ lib, stdenv, fetchurl, gnu-config, IOKit, Carbon }:

stdenv.mkDerivation rec {
  pname = "cdparanoia-III";
  version = "10.2";

  src = fetchurl {
    url =
      "https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-${version}.src.tgz";
    sha256 = "1pv4zrajm46za0f6lv162iqffih57a8ly4pc69f7y0gfyigb8p80";
  };

  patches = lib.optionals stdenv.isDarwin [
    (fetchurl {
      url =
        "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/osx_interface.patch";
      sha256 = "1n86kzm2ssl8fdf5wlhp6ncb2bf6b9xlb5vg0mhc85r69prqzjiy";
    })
    (fetchurl {
      url =
        "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/patch-paranoia_paranoia.c.10.4.diff";
      sha256 = "17l2qhn8sh4jy6ryy5si6ll6dndcm0r537rlmk4a6a8vkn852vad";
    })
  ] ++ lib.optional stdenv.hostPlatform.isMusl ./utils.patch
    ++ [ ./fix_private_keyword.patch ];

  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ Carbon IOKit ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    unset CC
  '' + lib.optionalString (!stdenv.hostPlatform.isx86) ''
    cp ${gnu-config}/config.sub configure.sub
    cp ${gnu-config}/config.guess configure.guess
  '';

  # Build system reuses the same object file names for shared and static
  # library. Occasionally fails in the middle:
  #    gcc -O2 -fsigned-char -g -O2 -c scan_devices.c
  #    rm  -f *.o core *~ *.out
  #    gcc -O2 -fsigned-char -g -O2 -fpic -c scan_devices.c
  #    gcc -fpic -shared -o libcdda_interface.so.0.10.2 ... scan_devices.o ...
  #    scan_devices.o: file not recognized: file format not recognized
  enableParallelBuilding = false;

  meta = with lib; {
    homepage = "https://xiph.org/paranoia";
    description = "A tool and library for reading digital audio from CDs";
    license = with licenses; [ gpl2Plus lgpl21Plus ];
    platforms = platforms.unix;
  };
}
