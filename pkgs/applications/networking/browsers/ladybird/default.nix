{ lib
, stdenv
, fetchFromGitHub
, fetchzip
, fetchurl
, cacert
, tzdata
, unicode-emoji
, unicode-character-database
, darwin
, cmake
, ninja
, libxcrypt
, qt6Packages
, nixosTests
, AppKit
, Cocoa
, Foundation
, OpenGL
}:

let
  inherit (builtins) elemAt;
  cldr_version = "44.1.0";
  cldr-json = fetchzip {
    url = "https://github.com/unicode-org/cldr-json/releases/download/${cldr_version}/cldr-${cldr_version}-json-modern.zip";
    stripRoot = false;
    hash = "sha256-EbbzaaspKgRT/dsJV3Kf0Dfj8LN9zT+Pl4gk5kiOXWk=";
    postFetch = ''
      echo -n ${cldr_version} > $out/version.txt
    '';
  };
  unicode-idna = fetchurl {
    url = "https://www.unicode.org/Public/idna/${unicode-character-database.version}/IdnaMappingTable.txt";
    hash = "sha256-QCy9KF8flS/NCDS2NUHVT2nT2PG4+Fmb9xoaFJNfgsQ=";
  };
  adobe-icc-profiles = fetchurl {
    url = "https://download.adobe.com/pub/adobe/iccprofiles/win/AdobeICCProfilesCS4Win_end-user.zip";
    hash = "sha256-kgQ7fDyloloPaXXQzcV9tgpn3Lnr37FbFiZzEb61j5Q=";
    name = "adobe-icc-profiles.zip";
  };
  public_suffix_commit = "9094af5c6cb260e69137c043c01be18fee01a540";
  public-suffix-list = fetchurl {
    url = "https://raw.githubusercontent.com/publicsuffix/list/${public_suffix_commit}/public_suffix_list.dat";
    hash = "sha256-0szHUz1T0MXOQ9tcXoKY2F/bI3s7hsYCjURqywZsf1w=";
  };
  # Note: The cacert version is synthetic and must match the version in the package's CMake
  cacert_version = "2023-12-12";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ladybird";
  version = "0-unstable-2024-03-16";

  src = fetchFromGitHub {
    owner = "SerenityOS";
    repo = "serenity";
    rev = "3a8bde9ef24dace600484b38992fdc7d17bf92c3";
    hash = "sha256-r8HYcexrOjDYsXuCtROiNY7Rl60pVQBvVQf190gqNuY=";
  };

  sourceRoot = "${finalAttrs.src.name}/Ladybird";

  postPatch = ''
    sed -i '/iconutil/d' CMakeLists.txt

    # Don't set absolute paths in RPATH
    substituteInPlace ../Meta/CMake/lagom_install_options.cmake \
      --replace-fail "\''${CMAKE_INSTALL_BINDIR}" "bin" \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}" "lib"
  '';

  preConfigure = ''
    # Setup caches for LibLocale, LibUnicode, LibTimezone, LibTLS and LibGfx
    # Note that the versions of the input data packages must match the
    # expected version in the package's CMake.
    mkdir -p build/Caches

    ln -s ${cldr-json} build/Caches/CLDR

    cp -r ${unicode-character-database}/share/unicode build/Caches/UCD
    chmod +w build/Caches/UCD
    cp ${unicode-emoji}/share/unicode/emoji/emoji-test.txt build/Caches/UCD
    cp ${unicode-idna} build/Caches/UCD/IdnaMappingTable.txt
    echo -n ${unicode-character-database.version} > build/Caches/UCD/version.txt
    chmod -w build/Caches/UCD

    mkdir build/Caches/TZDB
    tar -xzf ${elemAt tzdata.srcs 0} -C build/Caches/TZDB
    echo -n ${tzdata.version} > build/Caches/TZDB/version.txt

    mkdir build/Caches/CACERT
    cp ${cacert}/etc/ssl/certs/ca-bundle.crt build/Caches/CACERT/cacert-${cacert_version}.pem
    echo -n ${cacert_version} > build/Caches/CACERT/version.txt

    mkdir build/Caches/PublicSuffix
    cp ${public-suffix-list} build/Caches/PublicSuffix/public_suffix_list.dat

    mkdir build/Caches/AdobeICCProfiles
    cp ${adobe-icc-profiles} build/Caches/AdobeICCProfiles/adobe-icc-profiles.zip
    chmod +w build/Caches/AdobeICCProfiles
  '';

  nativeBuildInputs = with qt6Packages; [
    cmake
    ninja
    wrapQtAppsHook
  ];

  buildInputs = with qt6Packages; [
    libxcrypt
    qtbase
    qtmultimedia
  ] ++ lib.optionals stdenv.isDarwin [
    AppKit
    Cocoa
    Foundation
    OpenGL
  ];

  cmakeFlags = [
    # Disable network operations
    "-DSERENITY_CACHE_DIR=Caches"
    "-DENABLE_NETWORK_DOWNLOADS=OFF"
    "-DENABLE_COMMONMARK_SPEC_DOWNLOAD=OFF"
  ] ++ lib.optionals stdenv.isLinux [
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
    # FIXME: Enable this when launching with the commandline flag --enable-gpu-painting doesn't fail calling eglBindAPI on GNU/Linux
    "-DENABLE_ACCELERATED_GRAPHICS=OFF"
  ];

  # FIXME: Add an option to -DENABLE_QT=ON on macOS to use Qt rather than Cocoa for the GUI
  # FIXME: Add an option to enable PulseAudio rather than using Qt multimedia on non-macOS

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  postInstall = lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications $out/bin
    mv $out/bundle/Ladybird.app $out/Applications
  '';

  # Only Ladybird and WebContent need wrapped, if Qt is enabled.
  # On linux we end up wraping some non-Qt apps, like headless-browser.
  dontWrapQtApps = stdenv.isDarwin;

  passthru.tests = {
    nixosTest = nixosTests.ladybird;
  };

  meta = with lib; {
    description = "A browser using the SerenityOS LibWeb engine with a Qt or Cocoa GUI";
    homepage = "https://ladybird.dev";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    platforms = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" ];
    mainProgram = "Ladybird";
  };
})
