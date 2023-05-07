{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, copyDesktopItems
, pkg-config
, wrapGAppsHook
, unzip
, curl
, glib
, gtk3
, libssh2
, openssl
, wxGTK32
, gitUpdater
, makeDesktopItem
}:

stdenv.mkDerivation rec {
  pname = "freefilesync";
  version = "12.2";

  src = fetchFromGitHub {
    owner = "hkneptune";
    repo = "FreeFileSync";
    rev = "v${version}";
    hash = "sha256-pCXMpK+NF06vgEgX31wyO24+kPhvPhdTeRk1j84nYd0=";
  };

  # Patches from Debian
  patches = [
    # Disable loading of the missing Animal.dat
    (fetchpatch {
      url = "https://sources.debian.org/data/main/f/freefilesync/12.0-2/debian/patches/ffs_devuan.patch";
      excludes = [ "FreeFileSync/Source/ffs_paths.cpp" ];
      hash = "sha256-6pHr5txabMTpGMKP7I5oe1lGAmgb0cPW8ZkPv/WXN74=";
    })
    # Fix build with GTK 3
    (fetchpatch {
      url = "https://sources.debian.org/data/main/f/freefilesync/12.0-2/debian/patches/ffs_devuan_gtk3.patch";
      hash = "sha256-0n58Np4JI3hYK/CRBytkPHl9Jp4xK+IRjgUvoYti/f4=";
    })
  ];

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    wrapGAppsHook
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
      categories = [ "Utility" "FileTools" ];
    })
    (makeDesktopItem rec {
      name = "RealTimeSync";
      desktopName = name;
      genericName = "Automated Synchronization";
      icon = name;
      exec = name;
      categories = [ "Utility" "FileTools" ];
    })
  ];

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = with lib; {
    description = "Open Source File Synchronization & Backup Software";
    homepage = "https://freefilesync.org";
    license = [ licenses.gpl3Only licenses.openssl licenses.curl licenses.libssh2 ];
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.linux;
  };
}
