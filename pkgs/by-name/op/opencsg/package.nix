{
  lib,
  stdenv,
  fetchurl,
  cmake,
  libGLU,
  libGL,
  libglut,
  glew,
  libXmu,
  libXext,
  libX11,
  fixDarwinDylibNames,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "opencsg";
  version = "1.8.1";

  src = fetchurl {
    url = "http://www.opencsg.org/OpenCSG-${finalAttrs.version}.tar.gz";
    hash = "sha256-r8wASontO8R4qeS6ObIPPVibJOI+J1tzg/kaWQ1NV8U=";
  };

  patches = lib.optionals stdenv.hostPlatform.isDarwin [ ./opencsgexample.patch ];

  nativeBuildInputs = [ cmake ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = [
    glew
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    libGL
    libglut
    libXmu
    libXext
    libX11
  ];

  doCheck = false;

  postInstall = ''
    install -D ../copying.txt "$out/share/doc/opencsg/copying.txt"
  '';

  postFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    app=$out/Applications/opencsgexample.app/Contents/MacOS/opencsgexample
    install_name_tool -change \
      $(otool -L $app | awk '/opencsg.+dylib/ { print $1 }') \
      $(otool -D $out/lib/libopencsg.dylib | tail -n 1) \
      $app
  '';

  meta = {
    description = "Constructive Solid Geometry library";
    mainProgram = "opencsgexample";
    homepage = "http://www.opencsg.org/";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.raskin ];
    license = lib.licenses.gpl2Plus;
  };
})
