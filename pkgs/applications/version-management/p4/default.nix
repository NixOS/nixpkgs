{ stdenv
, fetchurl
, fetchzip
, lib
, emptyDirectory
, linkFarm
, jam
, openssl
, xcbuild
, CoreServices
, Foundation
, Security
}:

let
  opensslStatic = openssl.override {
    static = true;
  };
  androidZlibContrib =
    let
      src = fetchzip {
        url = "https://android.googlesource.com/platform/external/zlib/+archive/61174f4fd262c6075f88768465f308aae95a2f04.tar.gz";
        sha256 = "sha256-EMzKAHcEWOUugcHKH2Fj3ZaIHC9UlgO4ULKe3RvgxvI=";
        stripRoot = false;
      };
    in
    linkFarm "android-zlib-contrib" [
      # We only want to keep the contrib directory as the other files conflict
      # with p4's own zlib files. (For the same reason, we can't use the
      # cone-based Git sparse checkout, either.)
      { name = "contrib"; path = "${src}/contrib"; }
    ];
in
stdenv.mkDerivation rec {
  pname = "p4";
  version = "2022.2.2407422";

  src = fetchurl {
    # Upstream replaces minor versions, so use archived URL.
    url = "https://web.archive.org/web/20230512173806id_/https://ftp.perforce.com/perforce/r22.2/bin.tools/p4source.tgz";
    sha256 = "4355375def3f3d2256d4a92ac1b9960173e7aa97404346c0c74caf23a0905e1b";
  };

  nativeBuildInputs = [ jam ];

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices Foundation Security ];

  outputs = [ "out" "bin" "dev" ];

  hardeningDisable = lib.optionals stdenv.isDarwin [ "strictoverflow" ];

  jamFlags =
    [
      "-sEXEC=bin.unix"
      "-sCROSS_COMPILE=${stdenv.cc.targetPrefix}"
      "-sMALLOC_OVERRIDE=no"
      "-sSSLINCDIR=${lib.getDev opensslStatic}/include"
      "-sSSLLIBDIR=${lib.getLib opensslStatic}/lib"
    ]
    ++ lib.optionals stdenv.cc.isClang [ "-sOSCOMP=clang" "-sCLANGVER=${stdenv.cc.cc.version}" ]
    ++ lib.optionals stdenv.cc.isGNU [ "-sOSCOMP=gcc" "-sGCCVER=${stdenv.cc.cc.version}" ]
    ++ lib.optionals stdenv.isLinux [ "-sOSVER=26" ]
    ++ lib.optionals stdenv.isDarwin [
      "-sOSVER=1013"
      "-sMACOSX_SDK=${emptyDirectory}"
      "-sLIBC++DIR=${lib.getLib stdenv.cc.libcxx}/lib"
    ];

  CCFLAGS =
    # The file contrib/optimizations/slide_hash_neon.h is missing from the
    # upstream distribution. It comes from the Android/Chromium sources.
    lib.optionals stdenv.isAarch64 [ "-I${androidZlibContrib}" ];

  "C++FLAGS" =
    # Avoid a compilation error that only occurs for 4-byte longs.
    lib.optionals stdenv.isi686 [ "-Wno-narrowing" ]
    # See the "Header dependency changes" section of
    # https://www.gnu.org/software/gcc/gcc-11/porting_to.html for more
    # information on why we need to include these.
    ++ lib.optionals
      (stdenv.cc.isClang || (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.cc.version "11.0.0"))
      [ "-include" "limits" "-include" "thread" ];

  buildPhase = ''
    runHook preBuild
    jam $jamFlags -j$NIX_BUILD_CORES p4
    jam $jamFlags -j$NIX_BUILD_CORES -sPRODUCTION=yes p4api.tar
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $bin/bin $dev $out
    cp bin.unix/p4 $bin/bin
    cp -r bin.unix/p4api-${version}/include $dev
    cp -r bin.unix/p4api-${version}/lib $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Perforce Helix Core command-line client and APIs";
    homepage = "https://www.perforce.com";
    license = licenses.bsd2;
    mainProgram = "p4";
    platforms = platforms.unix;
    maintainers = with maintainers; [ corngood impl ];
  };
}
