{ stdenv, fetchFromGitHub, cmake, llvmPackages, pkgconfig, mpd_clientlib, openssl }:

stdenv.mkDerivation rec {
  name = "ympd-${version}";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "notandy";
    repo = "ympd";
    rev = "v${version}";
    sha256 = "1nvb19jd556v2h2bi7w4dcl507p3p8xvjkqfzrcsy7ccy3502brq";
  };

  preConfigure = ''
    export LIBMPDCLIENT_LIBS=${mpd_clientlib}/lib/libmpdclient.${if stdenv.isDarwin then mpd_clientlib.majorVersion + ".dylib" else "so." + mpd_clientlib.majorVersion + ".0." + mpd_clientlib.minorVersion}
    export LIBMPDCLIENT_CFLAGS=${mpd_clientlib}

    export LIBCLANG_CXXFLAGS="-isystem ${llvmPackages.clang.cc}/include $(llvm-config --cxxflags)"
    export LIBCLANG_LIBDIR="${llvmPackages.clang.cc}/lib"
  '';

  buildInputs = [ cmake pkgconfig mpd_clientlib openssl ];

  meta = {
    homepage = "http://www.ympd.org";
    description = "Standalone MPD Web GUI written in C, utilizing Websockets and Bootstrap/JS";
    maintainers = [ stdenv.lib.maintainers.siddharthist ];
    platforms = stdenv.lib.platforms.all;
  };
}
