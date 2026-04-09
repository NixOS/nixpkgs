{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  makeWrapper,
  openjdk21,
  libGL,
  libX11,
  fontconfig,
  freetype,
  libxext,
  libxrender,
  libxtst,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "husi";
  version = "1.1.1";

  src = fetchurl {
    url = "https://codeberg.org/xchacha20-poly1305/husi/releases/download/v${finalAttrs.version}/fr.husi_${finalAttrs.version}_amd64.deb";
    hash = "sha256-xdg1120vl2L2IuYs7zHHBZ8T2rrW9twcyOxw/bMv3Gc=";
  };

  nativeBuildInputs = [
    dpkg
    makeWrapper
  ];

  buildInputs = [
    libGL
    libX11
    fontconfig
    freetype
    libxext
    libxrender
    libxtst
  ];

  dontConfigure = true;
  dontBuild = true;

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x $src .
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/libexec/husi
    mkdir -p $out/bin

    cp -r usr/lib/fr.husi/. $out/libexec/husi/
    cp -r usr/share $out/

    makeWrapper ${openjdk21}/bin/java $out/bin/husi \
      --add-flags "-jar $out/libexec/husi/app/fr.husi.jar" \
      --set JAVA_HOME ${openjdk21} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          libX11
          fontconfig
          freetype
          libxext
          libxrender
          libxtst
        ]
      }

    runHook postInstall
  '';

  meta = {
    description = "Non-professional and recreational proxy tool integration";
    homepage = "https://codeberg.org/xchacha20-poly1305/husi";
    license = lib.licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ Dichgrem ];
    mainProgram = "husi";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
