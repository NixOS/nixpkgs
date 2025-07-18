{
  lib,
  stdenv,
  fetchurl,
  desktop-file-utils,
  makeWrapper,
  patchelf,
  fontconfig,
  freetype,
  glib,
  libICE,
  libSM,
  libX11,
  libXext,
  libXrender,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "spideroak";
  version = "7.5.2";

  src = fetchurl {
    url = "https://spideroak-releases.s3.us-east-2.amazonaws.com/SpiderOakONE-${finalAttrs.version}-x86_64-1.tgz";
    hash = "sha256-L9AF5gOmvbN+Ur1k0oIjJJT15RZvWA7mhDgveVowu7E=";
  };

  sourceRoot = ".";

  unpackCmd = "tar -xzf $curSrc";

  nativeBuildInputs = [
    desktop-file-utils
    patchelf
    makeWrapper
  ];

  installPhase = ''
    runHook preInstall

    cp -r . $out
    mv $out/usr/share $out/share
    rm -rf $out/usr

    rm -f $out/opt/SpiderOakONE/lib/libz*

    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 \
      "$out/opt/SpiderOakONE/lib/SpiderOakONE"

    makeWrapper $out/opt/SpiderOakONE/lib/SpiderOakONE $out/bin/spideroak \
      --set LD_LIBRARY_PATH $out/opt/SpiderOakONE/lib:${
        lib.makeLibraryPath [
          fontconfig
          freetype
          glib
          libICE
          libSM
          libX11
          libXext
          libXrender
          zlib
        ]
      } \
      --set QT_PLUGIN_PATH $out/opt/SpiderOakONE/lib/plugins/ \
      --set SpiderOak_EXEC_SCRIPT $out/bin/spideroak

    desktop-file-edit $out/share/applications/SpiderOakONE.desktop \
      --set-key="Exec" --set-value="spideroak"

    runHook postInstall
  '';

  meta = {
    homepage = "https://spideroak.com";
    description = "Secure online backup and sychronization";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ amorsillo ];
    platforms = lib.platforms.linux;
    mainProgram = "spideroak";
  };
})
