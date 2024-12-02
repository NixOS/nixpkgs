{ lib, stdenv, fetchurl, fetchpatch, cmake, pkg-config, boost, gd, libogg, libtheora, libvorbis }:

stdenv.mkDerivation rec {
  pname = "oggvideotools";
  version = "0.9.1";

  src = fetchurl {
    url = "mirror://sourceforge/oggvideotools/oggvideotools/oggvideotools-${version}/oggvideotools-${version}.tar.bz2";
    sha256 = "sha256-2dv3iXt86phhIgnYC5EnRzyX1u5ssNzPwrOP4+jilSM=";
  };

  patches = [
    # Fix pending upstream inclusion for missing includes:
    #  https://sourceforge.net/p/oggvideotools/bugs/12/
    (fetchpatch {
      name = "gcc-10.patch";
      url = "https://sourceforge.net/p/oggvideotools/bugs/12/attachment/fix-compile.patch";
      sha256 = "sha256-mJttoC3jCLM3vmPhlyqh+W0ryp2RjJGIBXd6sJfLJA4=";
    })

    # Fix pending upstream inclusion for build failure on gcc-12:
    #  https://sourceforge.net/p/oggvideotools/bugs/13/
    (fetchpatch {
      name = "gcc-12.patch";
      url = "https://sourceforge.net/p/oggvideotools/bugs/13/attachment/fix-gcc-12.patch";
      sha256 = "sha256-zuDXe86djWkR8SgYZHkuAJJ7Lf2VYsVRBrlEaODtMKE=";
      # svn patch, rely on prefix added by fetchpatch:
      extraPrefix = "";
    })
  ];

  postPatch = ''
    # Don't disable optimisations
    substituteInPlace CMakeLists.txt --replace " -O0 " ""
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ boost gd libogg libtheora libvorbis ];

  meta = with lib; {
    description = "Toolbox for manipulating and creating Ogg video files";
    homepage = "http://www.streamnik.de/oggvideotools.html";
    license = licenses.gpl2Only;
    maintainers = [ ];
    # Compilation error on Darwin:
    # error: invalid argument '--std=c++0x' not allowed with 'C'
    # make[2]: *** [src/libresample/CMakeFiles/resample.dir/build.make:76: src/libresample/CMakeFiles/resample.dir/filterkit.c.o] Error 1
    broken = stdenv.hostPlatform.isDarwin;
  };
}
