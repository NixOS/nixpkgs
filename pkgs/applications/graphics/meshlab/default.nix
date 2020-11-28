{ mkDerivation
, lib
, fetchFromGitHub
, fetchpatch
, libGLU
, qtbase
, qtscript
, qtxmlpatterns
, lib3ds
, bzip2
, muparser
, eigen
, glew
, gmp
, levmar
, qhull
, cmake
}:

mkDerivation rec {
  pname = "meshlab";
  version = "2020.07";

  src = fetchFromGitHub {
    owner = "cnr-isti-vclab";
    repo = "meshlab";
    rev = "Meshlab-${version}";
    sha256 = "0vj849b57zk3k6lx35zzcjhr9gdy4hxqnnkb8chwy7hw262cm3ri";
    fetchSubmodules = true; # for vcglib
  };

  buildInputs = [
    libGLU
    qtbase
    qtscript
    qtxmlpatterns
    lib3ds
    bzip2
    muparser
    eigen
    glew
    gmp
    levmar
    qhull
  ];

  nativeBuildInputs = [ cmake ];

  patches = [
    # Make cmake use the system qhull. The next meshlab will not need this patch because it is already in master.
    (fetchpatch {
      url = "https://patch-diff.githubusercontent.com/raw/cnr-isti-vclab/meshlab/pull/747.patch";
      sha256 = "0wx9f6zn458xz3lsqcgvsbwh1pgi3g0lah93nlbsb0sagng7n565";
    })
  ];

  preConfigure = ''
    substituteAll ${./meshlab.desktop} install/linux/resources/meshlab.desktop
    cd src
  '';

  cmakeFlags = [
    "-DALLOW_BUNDLED_EIGEN=OFF"
    "-DALLOW_BUNDLED_GLEW=OFF"
    "-DALLOW_BUNDLED_LIB3DS=OFF"
    "-DALLOW_BUNDLED_MUPARSER=OFF"
    "-DALLOW_BUNDLED_QHULL=OFF"
    # disable when available in nixpkgs
    "-DALLOW_BUNDLED_OPENCTM=ON"
    "-DALLOW_BUNDLED_SSYNTH=ON"
    # some plugins are disabled unless these are on
    "-DALLOW_BUNDLED_NEWUOA=ON"
    "-DALLOW_BUNDLED_LEVMAR=ON"
  ];

  postFixup = ''
    patchelf --add-needed $out/lib/meshlab/libmeshlab-common.so $out/bin/.meshlab-wrapped
    patchelf --add-needed $out/lib/meshlab/libmeshlab-common.so $out/bin/.meshlabserver-wrapped
  '';

  # Meshlab is not format-security clean; without disabling hardening, we get:
  # src/common/GLLogStream.h:61:37: error: format not a string literal and no format arguments [-Werror=format-security]
  #  61 |         int chars_written = snprintf(buf, buf_size, f, std::forward<Ts>(ts)...);
  #     |
  hardeningDisable = [ "format" ];

  enableParallelBuilding = true;

  meta = {
    description = "A system for processing and editing 3D triangular meshes";
    homepage = "https://www.meshlab.net/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ viric ];
    platforms = with lib.platforms; linux;
  };
}
