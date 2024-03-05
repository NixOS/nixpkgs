{lib, stdenv, fetchurl, fetchpatch, boost, dash, freetype, libpng, pkg-config, SDL, which, zlib, nasm }:

stdenv.mkDerivation rec {
  pname = "mupen64plus";
  version = "2.5.9";

  src = fetchurl {
    url = "https://github.com/mupen64plus/mupen64plus-core/releases/download/${version}/mupen64plus-bundle-src-${version}.tar.gz";
    sha256 = "1a21n4gqdvag6krwcjm5bnyw5phrlxw6m0mk73jy53iq03f3s96m";
  };

  patches = [
    # Pull upstream fix for -fno-common toolchains:
    #  https://github.com/mupen64plus/mupen64plus-core/pull/736
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/mupen64plus/mupen64plus-core/commit/39975200ad4926cfc79c96609b64696289065502.patch";
      sha256 = "0kdshp9xdkharn3d1g1pvxhh761pa1v5w07iq0wf9l380r2m6gbv";
      # a/something -> a/source/mupen64plus-core/something
      stripLen = 1;
      extraPrefix = "source/mupen64plus-core/";
    })
  ];

  nativeBuildInputs = [ pkg-config nasm ];
  buildInputs = [ boost dash freetype libpng SDL which zlib ];

  buildPhase = ''
    dash m64p_build.sh PREFIX="$out" COREDIR="$out/lib/" PLUGINDIR="$out/lib/mupen64plus" SHAREDIR="$out/share/mupen64plus"
  '';
  installPhase = ''
    dash m64p_install.sh DESTDIR="$out" PREFIX=""
  '';

  meta = with lib; {
    description = "A Nintendo 64 Emulator";
    license = licenses.gpl2Plus;
    homepage = "http://www.mupen64plus.org/";
    maintainers = [ maintainers.sander ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "mupen64plus";
  };
}
