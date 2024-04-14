{ lib
, stdenv
, fetchFromGitLab

, ApplicationServices
, asciidoctor
, bcg729
, bison
, buildPackages
, c-ares
, cmake
, flex
, gettext
, glib
, gmp
, gnutls
, libcap
, libgcrypt
, libgpg-error
, libkrb5
, libmaxminddb
, libnl
, libopus
, libpcap
, libsmi
, libssh
, lua5
, lz4
, makeWrapper
, minizip
, nghttp2
, ninja
, openssl
, pcre2
, perl
, pkg-config
, python3
, sbc
, snappy
, spandsp3
, speexdsp
, SystemConfiguration
, wrapGAppsHook
, zlib
, zstd

, withQt ? true
, qt6 ? null
}:

assert withQt -> qt6 != null;

stdenv.mkDerivation rec {
  pname = "wireshark-${if withQt then "qt" else "cli"}";
  version = "4.0.14";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    repo = "wireshark";
    owner = "wireshark";
    rev = "v${version}";
    hash = "sha256-PDIqbmY3Gul+XhG7pcRPDqV/lHQ2R63Got2awYZf/oE=";
  };

  patches = [
    ./wireshark-lookup-dumpcap-in-path.patch
  ];

  depsBuildBuild = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    asciidoctor
    bison
    cmake
    flex
    makeWrapper
    ninja
    perl
    pkg-config
    python3
  ] ++ lib.optionals withQt [
    qt6.wrapQtAppsHook
    wrapGAppsHook
  ];

  buildInputs = [
    gettext
    pcre2
    libpcap
    lua5
    libssh
    nghttp2
    openssl
    libgcrypt
    libgpg-error
    gnutls
    libmaxminddb
    libopus
    bcg729
    spandsp3
    libkrb5
    speexdsp
    libsmi
    lz4
    snappy
    zstd
    minizip
    c-ares
    glib
    zlib
  ] ++ lib.optionals withQt (with qt6; [
    qt5compat
    qtbase
    qtmultimedia
    qtsvg
    qttools
  ]) ++ lib.optionals (withQt && stdenv.isLinux) [
    qt6.qtwayland
  ] ++ lib.optionals stdenv.isLinux [
    libcap
    libnl
    sbc
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
    gmp
    SystemConfiguration
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_wireshark=${if withQt then "ON" else "OFF"}"
    "-DENABLE_APPLICATION_BUNDLE=${if withQt && stdenv.isDarwin then "ON" else "OFF"}"
    # Fix `extcap` and `plugins` paths. See https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=16444
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DLEMON_C_COMPILER=cc"
    "-DUSE_qt6=ON"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DHAVE_C99_VSNPRINTF_EXITCODE=0"
    "-DHAVE_C99_VSNPRINTF_EXITCODE__TRYRUN_OUTPUT="
  ];

  # Avoid referencing -dev paths because of debug assertions.
  env.NIX_CFLAGS_COMPILE = toString [ "-DQT_NO_DEBUG" ];

  dontFixCmake = true;
  # Prevent double-wrapping, inject wrapper args manually instead.
  dontWrapGApps = true;

  shellHook = ''
    # to be able to run the resulting binary
    export WIRESHARK_RUN_FROM_BUILD_DIRECTORY=1
  '';

  postPatch = ''
    sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  postInstall = ''
    # to remove "cycle detected in the references"
    mkdir -p $dev/lib/wireshark
    mv $out/lib/wireshark/cmake $dev/lib/wireshark
  '' + (if stdenv.isDarwin && withQt then ''
    mkdir -p $out/Applications
    mv $out/bin/Wireshark.app $out/Applications/Wireshark.app

    for f in $(find $out/Applications/Wireshark.app/Contents/PlugIns -name "*.so"); do
        for dylib in $(otool -L $f | awk '/^\t*lib/ {print $1}'); do
            install_name_tool -change "$dylib" "$out/lib/$dylib" "$f"
        done
    done
  '' else
    lib.optionalString withQt ''
      pwd

      mkdir -pv $dev/include/{epan/{wmem,ftypes,dfilter},wsutil/wmem,wiretap}

      cp config.h $dev/include/wireshark/
      cp ../epan/*.h $dev/include/epan/
      cp ../epan/ftypes/*.h $dev/include/epan/ftypes/
      cp ../epan/dfilter/*.h $dev/include/epan/dfilter/
      cp ../include/ws_*.h $dev/include/
      cp ../wiretap/*.h $dev/include/wiretap/
      cp ../wsutil/*.h $dev/include/wsutil/
      cp ../wsutil/wmem/*.h $dev/include/wsutil/wmem/
    '');

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = with lib; {
    description = "Powerful network protocol analyzer";
    longDescription = ''
      Wireshark (formerly known as "Ethereal") is a powerful network
      protocol analyzer developed by an international team of networking
      experts. It runs on UNIX, macOS and Windows.
    '';
    homepage = "https://www.wireshark.org";
    changelog = "https://www.wireshark.org/docs/relnotes/wireshark-${version}.html";
    license = licenses.gpl2Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor fpletz paveloom ];
    mainProgram = if withQt then "wireshark" else "tshark";
  };
}
