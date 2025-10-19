{
  stdenvNoCC,
  fetchzip,
  dpkg,
  autoPatchelfHook,
  libx11,
  libpulseaudio,
  alsa-lib,
  glibmm,
  gtk3,
  gtkmm3,
  lib,

  installStandalone ? true,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "sforzando";
  version = "1.982~beta3";

  src = fetchzip {
    url = "https://sforzando.s3.us-east-1.amazonaws.com/LINUX_plogue-sforzando_${finalAttrs.version}_x86_64.zip";
    hash = "sha256-yTz+ZfBIi6jN2IZWYnk8AZsIRT2qc6lpaWKUfxaAJrs=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    libx11
    libpulseaudio
    alsa-lib
    glibmm
    gtk3.dev
    gtkmm3
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg -x $src/plogue-sforzando_${finalAttrs.version}_amd64.deb ./
    runHook postUnpack
  '';

  patchPhase = ''
    runHook prePatch
    sed -i "s+Exec=/opt/+Exec=$out/opt/+" usr/share/applications/plogue-sforzando.desktop
    runHook postPatch
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/* $out/
    cp -r opt $out/opt

    ${lib.optionalString installStandalone ''
      mkdir -p $out/bin
      ln -s $out/opt/Plogue/sforzando/sforzando $out/bin/sforzando
    ''}

    runHook postInstall
  '';

  meta = {
    description = "Free, highly SFZ 2.0 compliant sample player";
    homepage = "https://www.plogue.com/products/sforzando.html";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryBytecode ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.mrtnvgr ];
  }
  // lib.optionalAttrs installStandalone {
    mainProgram = "sforzando";
  };
})
