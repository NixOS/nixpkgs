{
  autoreconfHook,
  expat,
  fetchpatch,
  fetchurl,
  glib,
  gtk3-x11,
  lib,
  pkg-config,
  stdenv,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "rfdump";
  version = "1.6";

  src = fetchurl {
    url = "https://www.rfdump.org/dl/rfdump-${version}.tar.bz2";
    hash = "sha256-fbEmh7i3ug5GCeyJ2wT45bbDq0ZEOv8yH+MOJwzER4U=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rfdump/-/raw/debian/master/debian/patches/01_fix_desktop_file.patch";
      hash = "sha256-r6BR+eAg963GjcFvV6/1heW7uKi8tmi7j8LyxtpcgYk=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rfdump/-/raw/debian/master/debian/patches/03_fix-format-security-errors.patch";
      hash = "sha256-rQKvFeSQ09P46lhvlov51Oej0HurlR++5Yv4kCLn9J8=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rfdump/-/raw/debian/master/debian/patches/02_configure.in-preserve-CFLAGS.patch";
      hash = "sha256-4+Yj5I019ZkHbtE3s67miAlMeuV8aZdc9RzJrySLmgM=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rfdump/-/raw/debian/master/debian/patches/04_gcc10.patch";
      hash = "sha256-LTsBkdwvmZ11+gwfe/XaapxzLaEVu7CdtCw8mqJcXr4=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/pkg-security-team/rfdump/-/raw/debian/master/debian/patches/05_gtk3.patch";
      hash = "sha256-1y/JFePfnQMMVwqLYgUQyP/SNZRMHgV+cHjbHP6szQs=";
    })
  ];

  postPatch = ''
    substituteInPlace src/main.c --replace-fail "/usr/share/rfdump/rfdump.ui" "$out/share/rfdump/rfdump.ui"
    substituteInPlace src/Makefile.am --replace-fail "/usr/share/pixmaps" "$out/share/pixmaps"
    substituteInPlace src/tagtypes.c --replace-fail "/usr/share/rfdump/rfd_types.xml" "$out/share/rfdump/rfd_types.xml"
  '';

  configureFlags = [ "PREFIX=$out" ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    expat
    glib
    gtk3-x11
    zlib
  ];

  makeFlags = [ "LIBS=-lexpat" ];

  meta = {
    description = "Tool to detect RFID-Tags and show their meta information";
    homepage = "https://www.rfdump.org/";
    changelog = "https://salsa.debian.org/pkg-security-team/rfdump/-/blob/debian/master/ChangeLog";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "rfdump";
    platforms = lib.platforms.all;
  };
}
