{ stdenv, fetchurl, pkg-config, pcre, perl, flex, bison, gettext, libpcap, libnl, c-ares
, gnutls, libgcrypt, libgpgerror, geoip, openssl, lua5, python3, libcap, glib
, libssh, nghttp2, zlib, cmake, makeWrapper
, withQt ? true, qt5 ? null
, ApplicationServices, SystemConfiguration, gmp
}:

assert withQt  -> qt5  != null;

with stdenv.lib;

let
  version = "3.4.5";
  variant = if withQt then "qt" else "cli";
  pcap = libpcap.override { withBluez = stdenv.isLinux; };

in stdenv.mkDerivation {
  pname = "wireshark-${variant}";
  inherit version;
  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://www.wireshark.org/download/src/all-versions/wireshark-${version}.tar.xz";
    sha256 = "sha256-3hqv0QCh4SB8hQ0YDpfdkauNoPXra+7FRfclzbFF0zM=";
  };

  cmakeFlags = [
    "-DBUILD_wireshark=${if withQt then "ON" else "OFF"}"
    "-DENABLE_APPLICATION_BUNDLE=${if withQt && stdenv.isDarwin then "ON" else "OFF"}"
    # Fix `extcap` and `plugins` paths. See https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=16444
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  # Avoid referencing -dev paths because of debug assertions.
  NIX_CFLAGS_COMPILE = [ "-DQT_NO_DEBUG" ];

  nativeBuildInputs = [ bison cmake flex makeWrapper pkg-config ] ++ optional withQt qt5.wrapQtAppsHook;

  buildInputs = [
    gettext pcre perl libpcap lua5 libssh nghttp2 openssl libgcrypt
    libgpgerror gnutls geoip c-ares python3 glib zlib
  ] ++ optionals withQt  (with qt5; [ qtbase qtmultimedia qtsvg qttools ])
    ++ optionals stdenv.isLinux  [ libcap libnl ]
    ++ optionals stdenv.isDarwin [ SystemConfiguration ApplicationServices gmp ]
    ++ optionals (withQt && stdenv.isDarwin) (with qt5; [ qtmacextras ]);

  patches = [ ./wireshark-lookup-dumpcap-in-path.patch ];

  postPatch = ''
    sed -i -e '1i cmake_policy(SET CMP0025 NEW)' CMakeLists.txt
  '';

  preBuild = ''
    export LD_LIBRARY_PATH="$PWD/run"
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

    wrapQtApp $out/Applications/Wireshark.app/Contents/MacOS/Wireshark
  '' else optionalString withQt ''
    install -Dm644 -t $out/share/applications ../wireshark.desktop

    install -Dm644 ../image/wsicon.svg $out/share/icons/wireshark.svg
    mkdir $dev/include/{epan/{wmem,ftypes,dfilter},wsutil,wiretap} -pv

    cp config.h $dev/include/
    cp ../ws_*.h $dev/include
    cp ../epan/*.h $dev/include/epan/
    cp ../epan/wmem/*.h $dev/include/epan/wmem/
    cp ../epan/ftypes/*.h $dev/include/epan/ftypes/
    cp ../epan/dfilter/*.h $dev/include/epan/dfilter/
    cp ../wsutil/*.h $dev/include/wsutil/
    cp ../wiretap/*.h $dev/include/wiretap
  '');

  enableParallelBuilding = true;

  dontFixCmake = true;

  shellHook = ''
    # to be able to run the resulting binary
    export WIRESHARK_RUN_FROM_BUILD_DIRECTORY=1
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.wireshark.org/";
    description = "Powerful network protocol analyzer";
    license = licenses.gpl2Plus;

    longDescription = ''
      Wireshark (formerly known as "Ethereal") is a powerful network
      protocol analyzer developed by an international team of networking
      experts. It runs on UNIX, macOS and Windows.
    '';

    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
