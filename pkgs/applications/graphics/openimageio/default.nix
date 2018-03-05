{ stdenv, fetchFromGitHub, boost, cmake, ilmbase, libjpeg, libpng, libtiff
, opencolorio, openexr, unzip
}:

stdenv.mkDerivation rec {
  name = "openimageio-${version}";
  version = "1.8.8";

  src = fetchFromGitHub {
    owner = "OpenImageIO";
    repo = "oiio";
    rev = "Release-${version}";
    sha256 = "1jn4ph7giwxr65xxbm59i03wywnmxkqnpvqp0kcajl4k48vq3wkr";
  };

  outputs = [ "bin" "out" "dev" "doc" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost ilmbase libjpeg libpng 
    libtiff opencolorio openexr
    unzip
  ];

  cmakeFlags = [
    "-DUSE_PYTHON=OFF"
  ];

  preBuild = ''
    makeFlags="ILMBASE_HOME=${ilmbase.dev} OPENEXR_HOME=${openexr.dev} USE_PYTHON=0
      INSTALLDIR=$out dist_dir="
  '';

  postInstall = ''
    mkdir -p $bin
    mv $out/bin $bin/
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://www.openimageio.org;
    description = "A library and tools for reading and writing images";
    license = licenses.bsd3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
