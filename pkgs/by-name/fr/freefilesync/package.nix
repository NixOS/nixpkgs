{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  fetchDebianPatch,
  copyDesktopItems,
  pkg-config,
  wrapGAppsHook3,
  unzip,
  curl,
  glib,
  gtk3,
  libssh2,
  openssl,
  wxGTK32,
  makeDesktopItem,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freefilesync";
  version = "13.6";

  src = fetchurl {
    url = "https://freefilesync.org/download/FreeFileSync_${finalAttrs.version}_Source.zip";
    # The URL only redirects to the file on the second attempt
    postFetch = ''
      rm -f $out
      tryDownload "$url"
    '';
    hash = "sha256-lJ4LiisUy8w6OPd44wJufH+ol1YwjOfFQfqzj3HWb2w=";
  };

  sourceRoot = ".";

  # Patches from Debian
  patches = [
    # Disable loading of the missing Animal.dat
    (fetchpatch {
      url = "https://sources.debian.org/data/main/f/freefilesync/13.3-1/debian/patches/ffs_devuan.patch";
      excludes = [ "FreeFileSync/Source/ffs_paths.cpp" ];
      hash = "sha256-cW0Y9+ByQWGzMU4NFRSkW46KkxQB4jRZotHlCFniv5o=";
    })
    # Fix build with GTK 3
    (fetchDebianPatch {
      pname = "freefilesync";
      version = "13.3";
      debianRevision = "1";
      patch = "ffs_devuan_gtk3.patch";
      hash = "sha256-0n58Np4JI3hYK/CRBytkPHl9Jp4xK+IRjgUvoYti/f4=";
    })
    # Fix build with vanilla wxWidgets
    (fetchDebianPatch {
      pname = "freefilesync";
      version = "13.3";
      debianRevision = "1";
      patch = "Disable_wxWidgets_uncaught_exception_handling.patch";
      hash = "sha256-Fem7eDDKSqPFU/t12Jco8OmYC8FM9JgB4/QVy/ouvbI=";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook3
    unzip
  ];

  buildInputs = [
    curl
    glib
    gtk3
    libssh2
    openssl
    wxGTK32
  ];

  env.NIX_CFLAGS_COMPILE = toString [
    # Undef g_object_ref on GLib 2.56+
    "-DGLIB_VERSION_MIN_REQUIRED=GLIB_VERSION_2_54"
    "-DGLIB_VERSION_MAX_ALLOWED=GLIB_VERSION_2_54"
    # Define libssh2 constants
    "-DMAX_SFTP_READ_SIZE=30000"
    "-DMAX_SFTP_OUTGOING_SIZE=30000"
  ];

  buildPhase = ''
    runHook preBuild

    chmod +w FreeFileSync/Build
    cd FreeFileSync/Source
    make -j$NIX_BUILD_CORES
    cd RealTimeSync
    make -j$NIX_BUILD_CORES
    cd ../../..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -R FreeFileSync/Build/* $out
    mv $out/{Bin,bin}

    mkdir -p $out/share/pixmaps
    unzip -j $out/Resources/Icons.zip '*Sync.png' -d $out/share/pixmaps

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem rec {
      name = "FreeFileSync";
      desktopName = name;
      genericName = "Folder Comparison and Synchronization";
      icon = name;
      exec = name;
      categories = [
        "Utility"
        "FileTools"
      ];
    })
    (makeDesktopItem rec {
      name = "RealTimeSync";
      desktopName = name;
      genericName = "Automated Synchronization";
      icon = name;
      exec = name;
      categories = [
        "Utility"
        "FileTools"
      ];
    })
  ];

  meta = with lib; {
    description = "Open Source File Synchronization & Backup Software";
    homepage = "https://freefilesync.org";
    license = [
      licenses.gpl3Only
      licenses.openssl
      licenses.curl
      licenses.libssh2
    ];
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.linux;
  };
})
