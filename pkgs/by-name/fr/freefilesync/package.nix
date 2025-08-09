{
  lib,
  stdenv,
  fetchurl,
  replaceVars,
  fetchDebianPatch,
  fetchFromGitHub,
  copyDesktopItems,
  pkg-config,
  wrapGAppsHook3,
  unzip,
  curl,
  glib,
  gtk3,
  libidn2,
  libssh2,
  openssl,
  wxGTK32,
  makeDesktopItem,
}:

let
  wxwidgets_3_3 = wxGTK32.overrideAttrs (
    finalAttrs: previousAttrs: {
      version = "3.3.0-unstable-2025-02-02";
      src = fetchFromGitHub {
        owner = "wxWidgets";
        repo = "wxWidgets";
        rev = "969c5a46b5c1da57836f721a4ce5df9feaa437f9";
        fetchSubmodules = true;
        hash = "sha256-ODPE896xc5RxdyfIzdPB5fsTeBm3O+asYJd99fuW6AY=";
      };
      patches = [
        ./wxcolorhook.patch
      ];
      configureFlags = lib.subtractLists [
        "--disable-compat28"
        "--enable-unicode"
      ] previousAttrs.configureFlags;
    }
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "freefilesync";
  version = "14.4";

  src = fetchurl {
    url = "https://freefilesync.org/download/FreeFileSync_${finalAttrs.version}_Source.zip";
    # The URL only redirects to the file on the second attempt
    postFetch = ''
      rm -f $out
      tryDownload "$url"
    '';
    hash = "sha256-Jx/Q/RsCTy06kJfJeatqrEoTMz7wLZvPQ3bzFClvKWc=";
  };

  sourceRoot = ".";

  patches = [
    # Disable loading of the missing Animal.dat
    ./skip-missing-Animal.dat.patch
    # Fix build with GTK 3
    (replaceVars ./Makefile.patch {
      gtk3-dev = lib.getDev gtk3;
    })
    # Fix build with vanilla wxWidgets
    (fetchDebianPatch {
      pname = "freefilesync";
      version = "13.7";
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
    libidn2
    libssh2
    openssl
    wxwidgets_3_3
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
      licenses.bsd3
    ];
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.linux;
  };
})
