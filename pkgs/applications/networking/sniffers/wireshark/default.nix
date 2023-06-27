{ lib
, stdenv
, buildPackages
, fetchFromGitLab
, pkg-config
, pcre2
, perl
, flex
, bison
, gettext
, libpcap
, libnl
, c-ares
, gnutls
, libgcrypt
, libgpg-error
, libmaxminddb
, libopus
, bcg729
, spandsp3
, libkrb5
, speexdsp
, libsmi
, lz4
, snappy
, zstd
, minizip
, sbc
, openssl
, lua5
, python3
, libcap
, glib
, libssh
, nghttp2
, zlib
, cmake
, ninja
, makeWrapper
, wrapGAppsHook
, withQt ? true
, qt6 ? null
, ApplicationServices
, SystemConfiguration
, gmp
, asciidoctor
}:

assert withQt -> qt6 != null;

let
  version = "4.0.6";
  variant = if withQt then "qt" else "cli";
in
stdenv.mkDerivation {
  pname = "wireshark-${variant}";
  inherit version;
  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    repo = "wireshark";
    owner = "wireshark";
    rev = "v${version}";
    hash = "sha256-hQpnD1BWOdb1YuG2BaQI+q1EkkTF1Du/HezrYr/Fl7w=";
  };

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

  nativeBuildInputs = [ asciidoctor bison cmake ninja flex makeWrapper pkg-config python3 perl ]
    ++ lib.optionals withQt [ qt6.wrapQtAppsHook wrapGAppsHook ];

  depsBuildBuild = lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [ buildPackages.stdenv.cc ];

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
  ] ++ lib.optionals withQt (with qt6; [ qtbase qtmultimedia qtsvg qttools qt5compat ])
  ++ lib.optionals (withQt && stdenv.isLinux) [ qt6.qtwayland ]
  ++ lib.optionals stdenv.isLinux [ libcap libnl sbc ]
  ++ lib.optionals stdenv.isDarwin [ SystemConfiguration ApplicationServices gmp ];

  strictDeps = true;

  patches = [ ./wireshark-lookup-dumpcap-in-path.patch ];

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

  dontFixCmake = true;

  # Prevent double-wrapping, inject wrapper args manually instead.
  dontWrapGApps = true;
  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  shellHook = ''
    # to be able to run the resulting binary
    export WIRESHARK_RUN_FROM_BUILD_DIRECTORY=1
  '';

  meta = with lib; {
    homepage = "https://www.wireshark.org/";
    changelog = "https://www.wireshark.org/docs/relnotes/wireshark-${version}.html";
    description = "Powerful network protocol analyzer";
    license = licenses.gpl2Plus;

    longDescription = ''
      Wireshark (formerly known as "Ethereal") is a powerful network
      protocol analyzer developed by an international team of networking
      experts. It runs on UNIX, macOS and Windows.
    '';

    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor fpletz ];
    mainProgram = if withQt then "wireshark" else "tshark";
  };
}
