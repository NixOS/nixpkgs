{ lib, stdenv, buildPackages, fetchurl, pkg-config, pcre2, perl, flex, bison
, gettext, libpcap, libnl, c-ares, gnutls, libgcrypt, libgpg-error, geoip, openssl
, lua5, python3, libcap, glib, libssh, nghttp2, zlib, cmake, makeWrapper, wrapGAppsHook
, withQt ? true, qt5 ? null
, ApplicationServices, SystemConfiguration, gmp
, asciidoctor
}:

assert withQt  -> qt5  != null;

with lib;

let
  version = "4.0.3";
  variant = if withQt then "qt" else "cli";

in stdenv.mkDerivation {
  pname = "wireshark-${variant}";
  inherit version;
  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.wireshark.org/download/src/all-versions/wireshark-${version}.tar.xz";
    sha256 = "sha256-bFHhW8wK+5NzTmhtv/NU/9FZ9XC9KQS8u61vP+t+lRE=";
  };

  cmakeFlags = [
    "-DBUILD_wireshark=${if withQt then "ON" else "OFF"}"
    "-DENABLE_APPLICATION_BUNDLE=${if withQt && stdenv.isDarwin then "ON" else "OFF"}"
    # Fix `extcap` and `plugins` paths. See https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=16444
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DLEMON_C_COMPILER=cc"
  ] ++ lib.optionals (stdenv.buildPlatform != stdenv.hostPlatform) [
    "-DHAVE_C99_VSNPRINTF_EXITCODE=0"
    "-DHAVE_C99_VSNPRINTF_EXITCODE__TRYRUN_OUTPUT="
  ];

  # Avoid referencing -dev paths because of debug assertions.
  NIX_CFLAGS_COMPILE = [ "-DQT_NO_DEBUG" ];

  nativeBuildInputs = [ asciidoctor bison cmake flex makeWrapper pkg-config python3 perl ]
    ++ optionals withQt [ qt5.wrapQtAppsHook wrapGAppsHook ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  buildInputs = [
    gettext pcre2 libpcap lua5 libssh nghttp2 openssl libgcrypt
    libgpg-error gnutls geoip c-ares glib zlib
  ] ++ optionals withQt  (with qt5; [ qtbase qtmultimedia qtsvg qttools ])
    ++ optionals stdenv.isLinux  [ libcap libnl ]
    ++ optionals stdenv.isDarwin [ SystemConfiguration ApplicationServices gmp ]
    ++ optionals (withQt && stdenv.isDarwin) (with qt5; [ qtmacextras ]);

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
  '' else optionalString withQt ''
    pwd
    install -Dm644 -t $out/share/applications ../resources/freedesktop/org.wireshark.Wireshark.desktop

    install -Dm644 ../resources/icons/wsicon.svg $out/share/icons/wireshark.svg
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
