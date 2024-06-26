{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  updateAutotoolsGnuConfigScriptsHook,
  autoreconfHook,
  IOKit,
  Carbon,
}:

stdenv.mkDerivation rec {
  pname = "cdparanoia-III";
  version = "10.2";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-${version}.src.tgz";
    sha256 = "1pv4zrajm46za0f6lv162iqffih57a8ly4pc69f7y0gfyigb8p80";
  };

  patches =
    lib.optionals stdenv.isDarwin [
      (fetchpatch {
        url = "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/osx_interface.patch";
        sha256 = "0hq3lvfr0h1m3p0r33jij0s1aspiqlpy533rwv19zrfllb39qvr8";
        # Our configure patch will subsume it, but we want our configure
        # patch to be used on all platforms so we cannot just start where
        # this leaves off.
        excludes = [ "configure.in" ];
      })
      (fetchurl {
        url = "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/patch-paranoia_paranoia.c.10.4.diff";
        sha256 = "17l2qhn8sh4jy6ryy5si6ll6dndcm0r537rlmk4a6a8vkn852vad";
      })
    ]
    ++ [
      # Has to come after darwin patches
      ./fix_private_keyword.patch
      # Order does not matter
      ./configure.patch
    ]
    ++ lib.optional stdenv.hostPlatform.isMusl ./utils.patch;

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    autoreconfHook
  ];

  propagatedBuildInputs = lib.optionals stdenv.isDarwin [
    Carbon
    IOKit
  ];

  hardeningDisable = [ "format" ];

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
    description = "Tool and library for reading digital audio from CDs";
    license = with licenses; [
      gpl2Plus
      lgpl21Plus
    ];
    platforms = platforms.unix;
    mainProgram = "cdparanoia";
  };
}
