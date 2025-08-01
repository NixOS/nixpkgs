{
  lib,
  stdenv,
  symlinkJoin,
  fetchurl,
  fetchzip,
  scons,
  zlib,
  libiconv,
}:

stdenv.mkDerivation rec {
  pname = "nsis";
  version = "3.11";

  src = fetchurl {
    url = "mirror://sourceforge/project/nsis/NSIS%203/${version}/nsis-${version}-src.tar.bz2";
    sha256 = "19e72062676ebdc67c11dc032ba80b979cdbffd3886c60b04bb442cdd401ff4b";
  };
  srcWinDistributable = fetchzip {
    url = "mirror://sourceforge/project/nsis/NSIS%203/${version}/nsis-${version}.zip";
    sha256 = "e574f335ab9d3ad73118f46615e5c9f2a52f3e4622ecbb7e5886badbc8601348";
  };

  postUnpack = ''
    mkdir -p $out/share/nsis
    cp -avr ${srcWinDistributable}/{Contrib,Include,Plugins,Stubs} \
      $out/share/nsis
    chmod -R u+w $out/share/nsis
  '';

  nativeBuildInputs = [ scons ];
  buildInputs = [ zlib ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  CPPPATH = symlinkJoin {
    name = "nsis-includes";
    paths = [ zlib.dev ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];
  };

  LIBPATH = symlinkJoin {
    name = "nsis-libs";
    paths = [ zlib ] ++ lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];
  };

  sconsFlags = [
    "SKIPSTUBS=all"
    "SKIPPLUGINS=all"
    "SKIPUTILS=all"
    "SKIPMISC=all"
    "NSIS_CONFIG_CONST_DATA=no"
    "VERSION=${version}"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "APPEND_LINKFLAGS=-liconv";

  preBuild = ''
    sconsFlagsArray+=(
      "PATH=$PATH"
      "CC=$CC"
      "CXX=$CXX"
      "APPEND_CPPPATH=$CPPPATH/include"
      "APPEND_LIBPATH=$LIBPATH/lib"
    )
  '';

  prefixKey = "PREFIX=";
  installTargets = [ "install-compiler" ];

  meta = with lib; {
    description = "Free scriptable win32 installer/uninstaller system that doesn't suck and isn't huge";
    homepage = "https://nsis.sourceforge.io/";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ pombeirp ];
    mainProgram = "makensis";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
