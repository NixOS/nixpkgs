{
  stdenv,
  lib,
  fetchzip,
  libGL,
  libX11,
}:

stdenv.mkDerivation {
  pname = "soil";
  version = "unstable-2020-01-04";

  src = fetchzip {
    url = "https://web.archive.org/web/20200104042737id_/http://www.lonesock.net/files/soil.zip";
    sha256 = "1c05nwbnfdgwaz8ywn7kg2xrcvrcbpdyhcfkkiiwk69zvil0pbgd";
  };

  buildInputs = lib.optionals (!stdenv.hostPlatform.isDarwin) [
    libGL
    libX11
  ];

  buildPhase = ''
    cd src
    $CC $NIX_CFLAGS_COMPILE -c *.c
    $AR rcs libSOIL.a *.o
  '';
  installPhase = ''
    mkdir -p $out/lib $out/include/SOIL
    cp libSOIL.a $out/lib/
    cp SOIL.h $out/include/SOIL/
  '';

  meta = with lib; {
    description = "Simple OpenGL Image Library";
    longDescription = ''
      SOIL is a tiny C library used primarily for uploading textures
      into OpenGL.
    '';
    homepage = "https://www.lonesock.net/soil.html";
    license = licenses.publicDomain;
    platforms = platforms.unix;
    maintainers = with maintainers; [ r-burns ];
  };
}
