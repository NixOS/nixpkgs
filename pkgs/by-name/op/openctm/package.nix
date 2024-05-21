{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  freeglut,
  gtk2,
  libGLU,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openctm";
  version = "1.0.3";

  src = fetchurl {
    url = "https://downloads.sourceforge.net/project/openctm/OpenCTM-${finalAttrs.version}/OpenCTM-${finalAttrs.version}-src.tar.bz2";
    hash = "sha256-So0mCNlzZPfuxWt8Y3xWuTCK6YKGs+kNu3QTyQ6UPx0=";
  };

  outputs = [
    "bin"
    "dev"
    "man"
    "out"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    freeglut
    gtk2
    libGLU
  ];

  postPatch = ''
    substituteInPlace tools/tinyxml/Makefile.linux \
      --replace-warn "-Wno-format" "-Wno-format -Wno-format-security"
    substituteInPlace tools/Makefile.linux \
      --replace-warn "-lglut" "-lglut -lGL -lGLU"
  '';

  makeFlags = [
    "BINDIR=$(bin)/bin/"
    "INCDIR=$(dev)/include/"
    "LIBDIR=$(out)/lib/"
    "MAN1DIR=$(man)/share/man//man1"
  ];

  makefile = if stdenv.isDarwin then "Makefile.macosx" else "Makefile.linux";

  preInstall = "mkdir -p $bin/bin $dev/include $out/lib $man/share/man/man1";

  meta = with lib; {
    description = "File format, software library and a tool set for compression of 3D triangle meshes";
    homepage = "https://sourceforge.net/projects/openctm/";
    license = licenses.zlib;
    maintainers = with maintainers; [ nim65s ];
  };
})
