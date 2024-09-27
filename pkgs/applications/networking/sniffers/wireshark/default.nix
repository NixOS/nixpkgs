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
, fixDarwinDylibNames
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
, nghttp3
, ninja
, opencore-amr
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
, wrapGAppsHook3
, zlib
, zstd

, withQt ? true
, qt6 ? null
}:
let
  isAppBundle = withQt && stdenv.hostPlatform.isDarwin;
in
assert withQt -> qt6 != null;

stdenv.mkDerivation rec {
  pname = "wireshark-${if withQt then "qt" else "cli"}";
  version = "4.2.6";

  outputs = [ "out" "dev" ];

  src = fetchFromGitLab {
    repo = "wireshark";
    owner = "wireshark";
    rev = "v${version}";
    hash = "sha256-zlFTUgsEKraE9crS5SZ13r93JJzUb6eyBhusJbbGwsE=";
  };

  patches = [
    ./patches/lookup-dumpcap-in-path.patch
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
    wrapGAppsHook3
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    bcg729
    c-ares
    gettext
    glib
    gnutls
    libgcrypt
    libgpg-error
    libkrb5
    libmaxminddb
    libopus
    libpcap
    libsmi
    libssh
    lua5
    lz4
    minizip
    nghttp2
    nghttp3
    opencore-amr
    openssl
    pcre2
    snappy
    spandsp3
    speexdsp
    zlib
    zstd
  ] ++ lib.optionals withQt (with qt6; [
    qt5compat
    qtbase
    qtmultimedia
    qtsvg
    qttools
  ]) ++ lib.optionals (withQt && stdenv.hostPlatform.isLinux) [
    qt6.qtwayland
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
    libnl
    sbc
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    ApplicationServices
    gmp
    SystemConfiguration
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DBUILD_wireshark=${if withQt then "ON" else "OFF"}"
    # Fix `extcap` and `plugins` paths. See https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=16444
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DENABLE_APPLICATION_BUNDLE=${if isAppBundle then "ON" else "OFF"}"
    "-DLEMON_C_COMPILER=cc"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DHAVE_C99_VSNPRINTF_EXITCODE__TRYRUN_OUTPUT="
    "-DHAVE_C99_VSNPRINTF_EXITCODE=0"
  ];

  # Avoid referencing -dev paths because of debug assertions.
  env.NIX_CFLAGS_COMPILE = toString [ "-DQT_NO_DEBUG" ];

  dontFixCmake = true;
  dontWrapGApps = true;

  shellHook = ''
    # to be able to run the resulting binary
    export WIRESHARK_RUN_FROM_BUILD_DIRECTORY=1
  '';

  postPatch = ''
    sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  postInstall = ''
    cmake --install . --prefix "''${!outputDev}" --component Development
  '' + lib.optionalString isAppBundle ''
    mkdir -p $out/Applications
    mv $out/bin/Wireshark.app $out/Applications/Wireshark.app
  '' + lib.optionalString stdenv.hostPlatform.isDarwin ''
    local flags=()
    for file in $out/lib/*.dylib; do
      flags+=(-change @rpath/"$(basename "$file")" "$file")
    done

    for file in $out/lib/wireshark/extcap/*; do
      if [ -L "$file" ]; then continue; fi
      echo "$file: fixing dylib references"
      # note that -id does nothing on binaries
      install_name_tool -id "$file" "''${flags[@]}" "$file"
    done
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  # This is done to remove some binary wrappers that wrapQtApps adds in *.app directories.
  # Copying because unfortunately pointing Wireshark (when built as an appbundle) at $out/lib instead is nontrivial.
  postFixup = lib.optionalString isAppBundle ''
    rm -rf $out/Applications/Wireshark.app/Contents/MacOS/extcap $out/Applications/Wireshark.app/Contents/PlugIns
    mkdir -p $out/Applications/Wireshark.app/Contents/PlugIns/wireshark
    cp -r $out/lib/wireshark/plugins/4-2 $out/Applications/Wireshark.app/Contents/PlugIns/wireshark/4-2
    cp -r $out/lib/wireshark/extcap $out/Applications/Wireshark.app/Contents/MacOS/extcap
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
    maintainers = with maintainers; [ bjornfor fpletz ];
    mainProgram = if withQt then "wireshark" else "tshark";
  };
}
