{ lib
, stdenv
, fetchFromGitHub
, fetchzip
, fetchurl
, cacert
, tzdata
, unicode-emoji
, unicode-character-database
, cmake
, ninja
, pkg-config
, libavif
, libjxl
, libtiff
, libwebp
, libxcrypt
, python3
, qt6Packages
, woff2
, ffmpeg
, simdutf
, skia
, nixosTests
, AppKit
, Cocoa
, Foundation
, OpenGL
}:

let
  inherit (builtins) elemAt;
  cldr_version = "45.0.0";
  cldr-json = fetchzip {
    url = "https://github.com/unicode-org/cldr-json/releases/download/${cldr_version}/cldr-${cldr_version}-json-modern.zip";
    stripRoot = false;
    hash = "sha256-BPDvYjlvJMudX/YlS7HrwKEABYx+1KzjiFlLYA5+Oew=";
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
  version = "0-unstable-2024-08-12";

  src = fetchFromGitHub {
    owner = "LadybirdWebBrowser";
    repo = "ladybird";
    rev = "7e57cc7b090455e93261c847064f12a61d686ff3";
    hash = "sha256-8rkgxEfRH8ERuC7iplQKOzKb1EJ4+SNGDX5gTGpOmQo=";
  };

  postPatch = ''
    sed -i '/iconutil/d' Ladybird/CMakeLists.txt

    # Don't set absolute paths in RPATH
    substituteInPlace Meta/CMake/lagom_install_options.cmake \
      --replace-fail "\''${CMAKE_INSTALL_BINDIR}" "bin" \
      --replace-fail "\''${CMAKE_INSTALL_LIBDIR}" "lib"

    # libwebp is not built with cmake support yet
    # https://github.com/NixOS/nixpkgs/issues/334148
    cat > Meta/CMake/FindWebP.cmake <<'EOF'
    find_package(PkgConfig)
    pkg_check_modules(WEBP libwebp REQUIRED)
    include_directories(''${WEBP_INCLUDE_DIRS})
    link_directories(''${WEBP_LIBRARY_DIRS})
    EOF
    substituteInPlace Userland/Libraries/LibGfx/CMakeLists.txt \
      --replace-fail 'WebP::' "" \
      --replace-fail libwebpmux webpmux
  '';

  preConfigure = ''
    # Setup caches for LibLocale, LibUnicode, LibTimezone, LibTLS and LibGfx
    # Note that the versions of the input data packages must match the
    # expected version in the package's CMake.

    # Check that the versions match
    grep -F 'locale_version = "${cldr_version}"' Meta/gn/secondary/Userland/Libraries/LibLocale/BUILD.gn || (echo cldr_version mismatch && exit 1)
    grep -F 'tzdb_version = "${tzdata.version}"' Meta/gn/secondary/Userland/Libraries/LibTimeZone/BUILD.gn || (echo tzdata.version mismatch && exit 1)
    grep -F 'set(CACERT_VERSION "${cacert_version}")' Meta/CMake/ca_certificates_data.cmake || (echo cacert_version mismatch && exit 1)

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
    pkg-config
    python3
    wrapQtAppsHook
  ];

  buildInputs = with qt6Packages; [
    ffmpeg
    libavif
    libjxl
    libwebp
    libxcrypt
    qtbase
    qtmultimedia
    simdutf
    skia
    woff2
  ] ++ lib.optional stdenv.isLinux [
    qtwayland
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
  ] ++ lib.optionals stdenv.isLinux [
    "-DCMAKE_INSTALL_LIBEXECDIR=libexec"
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
    description = "Browser using the SerenityOS LibWeb engine with a Qt or Cocoa GUI";
    homepage = "https://ladybird.dev";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fgaz ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "Ladybird";
    # use of undeclared identifier 'NSBezelStyleAccessoryBarAction'
    broken = stdenv.isDarwin;
  };
})
