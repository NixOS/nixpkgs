{
  lib,
  stdenv,
  cmake,
  fetchurl,
  findutils,
  fixDarwinDylibNames,
  ninja,
  updateAutotoolsGnuConfigScriptsHook,
  sslSupport ? true,
  openssl,
  fetchpatch,
  windows,

  static ? stdenv.hostPlatform.isStatic,
}:

stdenv.mkDerivation rec {
  pname = "libevent";
  version = "2.1.12";

  # MSYS2 reference:
  # - fix-nixpkgs/MINGW-packages/mingw-w64-libevent/PKGBUILD (+ patch stack)
  isMinGW = stdenv.hostPlatform.isMinGW;

  src = fetchurl {
    url = "https://github.com/libevent/libevent/releases/download/release-${version}-stable/libevent-${version}-stable.tar.gz";
    sha256 = "1fq30imk8zd26x8066di3kpc5zyfc5z6frr3zll685zcx4dxxrlj";
  };

  patches =
    [
      # Don't define BIO_get_init() for LibreSSL 3.5+
      (fetchpatch {
        url = "https://github.com/libevent/libevent/commit/883630f76cbf512003b81de25cd96cb75c6cf0f9.patch";
        sha256 = "sha256-VPJqJUAovw6V92jpqIXkIR1xYGbxIWxaHr8cePWI2SU=";
      })
    ]
    ++ lib.optionals isMinGW [
      ./mingw/001-event2-02-win32.patch
      ./mingw/002-http-server-win32.patch
      ./mingw/003-cmake-update.patch
      ./mingw/004-time_t-compute.patch
      ./mingw/005-limit-MSVC-to-clang-cl.patch
      ./mingw/006-fix-build-on-aarch64.patch
      ./mingw/007-fix-dll-version.patch
      ./mingw/008-automatic-choose-linkage-type.patch
    ];

  configureFlags = lib.flatten [
    (lib.optional (!sslSupport) "--disable-openssl")
    # Avoid building sample programs on Windows in the autotools build.
    (lib.optional (stdenv.hostPlatform.isWindows && !isMinGW) "--disable-samples")
    (lib.optionals static [
      "--disable-shared"
      "--with-pic"
    ])
  ];

  cmakeGenerator = lib.optionalString isMinGW "Ninja";

  cmakeFlags = lib.optionals isMinGW (
    [
      "-DCMAKE_DLL_NAME_WITH_SOVERSION=ON"

      # NOTE: libevent's upstream CMake uses EVENT__LIBRARY_TYPE, but MSYS2 passes
      # EVENT_LIBRARY_TYPE. Set both for maximum compatibility across versions.
      "-DEVENT__LIBRARY_TYPE=${if static then "STATIC" else "BOTH"}"
      "-DEVENT_LIBRARY_TYPE=${if static then "STATIC" else "BOTH"}"

      "-DEVENT__DISABLE_BENCHMARK=ON"
      "-DEVENT__DISABLE_TESTS=ON"
      "-DEVENT__DISABLE_REGRESS=ON"
      "-DEVENT__DISABLE_SAMPLES=ON"
      "-DEVENT__DISABLE_MBEDTLS=ON"
    ]
    ++ lib.optional (!sslSupport) "-DEVENT__DISABLE_OPENSSL=ON"
  );

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isWindows "-DWINVER=0x0600 -D_WIN32_WINNT=0x0600";

  preConfigure = lib.optionalString (lib.versionAtLeast stdenv.hostPlatform.darwinMinVersion "11") ''
    MACOSX_DEPLOYMENT_TARGET=10.16
  '';

  # libevent_openssl is moved into its own output, so that openssl isn't present
  # in the default closure.
  outputs = [
    "out"
    "dev"
  ]
  ++ lib.optional sslSupport "openssl";
  outputBin = "dev";
  propagatedBuildOutputs = [ "out" ] ++ lib.optional sslSupport "openssl";

  nativeBuildInputs =
    lib.optionals (!isMinGW) [
      updateAutotoolsGnuConfigScriptsHook
    ]
    ++ lib.optionals isMinGW [
      cmake
      ninja
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs =
    lib.optional sslSupport openssl
    ++ lib.optional stdenv.hostPlatform.isCygwin findutils
    ++ lib.optionals isMinGW [ windows.pthreads ];

  doCheck = false; # needs the net

  postInstall = lib.optionalString sslSupport ''
    moveToOutput "lib/libevent_openssl*" "$openssl"

    # Fix pkg-config paths for Nix multi-output builds.
    #
    # The upstream CMake .pc generation can end up joining absolute install dirs
    # with the pkg-config "prefix" variable, resulting in strings like:
    #   libdir=$prefix//nix/store/...
    #
    # Normalize .pc files to refer to the correct outputs explicitly.
    for pc in "$out"/lib/pkgconfig/libevent*.pc; do
      [ -f "$pc" ] || continue

      pc_libdir="$out/lib"
      case "$pc" in
        */libevent_openssl.pc) pc_libdir="$openssl/lib" ;;
      esac

      sed -i \
        -e "s|^libdir=.*$|libdir=$pc_libdir|" \
        -e "s|^includedir=.*$|includedir=$dev/include|" \
        "$pc"
    done
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Event notification library";
    mainProgram = "event_rpcgen.py";
    longDescription = ''
      The libevent API provides a mechanism to execute a callback function
      when a specific event occurs on a file descriptor or after a timeout
      has been reached.  Furthermore, libevent also support callbacks due
      to signals or regular timeouts.

      libevent is meant to replace the event loop found in event driven
      network servers.  An application just needs to call event_dispatch()
      and then add or remove events dynamically without having to change
      the event loop.
    '';
    homepage = "https://libevent.org/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
