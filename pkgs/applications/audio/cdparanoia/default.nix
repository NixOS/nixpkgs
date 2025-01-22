{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  updateAutotoolsGnuConfigScriptsHook,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "cdparanoia-III";
  version = "10.2";

  src = fetchurl {
    url = "https://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-${version}.src.tgz";
    sha256 = "1pv4zrajm46za0f6lv162iqffih57a8ly4pc69f7y0gfyigb8p80";
  };

  patches =
    lib.optionals stdenv.hostPlatform.isDarwin [
      (fetchpatch {
        url = "https://github.com/macports/macports-ports/raw/c8e15973bc3c1e1ab371bc0ee2de14209e639f17/audio/cdparanoia/files/osx_interface.patch";
        hash = "sha256-9p4+9dRvqLHkpR0RWLQcNL1m7fb7L6r+c9Q2tt4jh0U=";
        # Our configure patch will subsume it, but we want our configure
        # patch to be used on all platforms so we cannot just start where
        # this leaves off.
        excludes = [ "configure.in" ];
      })
      (fetchurl {
        url = "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/patch-paranoia_paranoia.c.10.4.diff";
        hash = "sha256-TW1RkJ0bKaPIrDSfUTKorNlmKDVRF++z8ZJAjSzEgp4=";
      })
      # add missing include files needed for function prototypes
      (fetchpatch {
        url = "https://github.com/macports/macports-ports/raw/f210a6061bc53c746730a37922399c6de6d69cb7/audio/cdparanoia/files/fixing-include.patch";
        hash = "sha256-6a/u4b8/H/4XjyFup23xySgyAI9SMVMom4PLvH8KzhE=";
      })
    ]
    ++ [
      # Has to come after darwin patches
      ./fix_private_keyword.patch
      # Order does not matter
      ./configure.patch
      # labs for long
      (fetchpatch {
        url = "https://github.com/macports/macports-ports/raw/f210a6061bc53c746730a37922399c6de6d69cb7/audio/cdparanoia/files/fixing-labs.patch";
        hash = "sha256-BMMQ5bbPP3eevuwWUVjQCtRBiWbkAHD+O0C0fp+BPaw=";
      })
      # use "%s" for passing a buffer to fprintf
      (fetchpatch {
        url = "https://github.com/macports/macports-ports/raw/f210a6061bc53c746730a37922399c6de6d69cb7/audio/cdparanoia/files/fixing-fprintf.patch";
        hash = "sha256-2dJl16p+f5l3wxVOJhsuLiQ9a4prq7jsRZP8/ygEae4=";
      })
      # add support for IDE4-9
      (fetchpatch {
        url = "https://salsa.debian.org/optical-media-team/cdparanoia/-/raw/bbf353721834b3784ccc0fd54a36a6b25181f5a4/debian/patches/02-ide-devices.patch";
        hash = "sha256-S6OzftUIPPq9JHsoAE2K51ltsI1WkVaQrpgCjgm5AG4=";
      })
      # check buffer is non-null before dereferencing
      (fetchpatch {
        url = "https://salsa.debian.org/optical-media-team/cdparanoia/-/raw/f7bab3024c5576da1fdb7497abbd6abc8959a98c/debian/patches/04-endian.patch";
        hash = "sha256-krfprwls0L3hsNfoj2j69J5k1RTKEQtzE0fLYG9EJKo=";
      })
    ]
    ++ lib.optional stdenv.hostPlatform.isMusl ./utils.patch;

  nativeBuildInputs = [
    updateAutotoolsGnuConfigScriptsHook
    autoreconfHook
  ];

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
