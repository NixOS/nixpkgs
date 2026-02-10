{
  lib,
  stdenv,
  fetchurl,
  jdk,
  makeWrapper,
  autoPatchelfHook,
  makeDesktopItem,
  glib,
  libsecret,
  webkitgtk_4_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "apache-directory-studio";
  version = "2.0.0-M17";
  versionWithDate = "2.0.0.v20210717-M17";

  src =
    if stdenv.hostPlatform.system == "x86_64-linux" then
      fetchurl {
        url = "mirror://apache/directory/studio/${finalAttrs.versionWithDate}/ApacheDirectoryStudio-${finalAttrs.versionWithDate}-linux.gtk.x86_64.tar.gz";
        sha256 = "19zdspzv4n3mfgb1g45s3wh0vbvn6a9zjd4xi5x2afmdjkzlwxi4";
      }
    else
      throw "Unsupported system: ${stdenv.hostPlatform.system}";

  desktopItem = makeDesktopItem {
    name = "apache-directory-studio";
    exec = "ApacheDirectoryStudio";
    icon = "apache-directory-studio";
    comment = "Eclipse-based LDAP browser and directory client";
    desktopName = "Apache Directory Studio";
    genericName = "Apache Directory Studio";
    categories = [
      "Java"
      "Network"
    ];
  };

  buildInputs = [
    glib
    libsecret
  ];
  nativeBuildInputs = [
    makeWrapper
    autoPatchelfHook
  ];

  installPhase = ''
    dest="$out/libexec/ApacheDirectoryStudio"
    mkdir -p "$dest"
    cp -r . "$dest"

    mkdir -p "$out/bin"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        "$dest/ApacheDirectoryStudio"

    # About `/tmp/SWT-GDBusServer`, see
    # https://github.com/adoptium/adoptium-support/issues/785#issuecomment-1866680133
    # and
    # https://github.com/adoptium/adoptium-support/issues/785#issuecomment-2387481967.
    makeWrapper "$dest/ApacheDirectoryStudio" \
        "$out/bin/ApacheDirectoryStudio" \
        --prefix PATH : "${jdk}/bin" \
        --prefix LD_LIBRARY_PATH : ${
          lib.makeLibraryPath [
            glib
            webkitgtk_4_1
          ]
        } \
        --run "mkdir -p /tmp/SWT-GDBusServer"
    install -D icon.xpm "$out/share/pixmaps/apache-directory-studio.xpm"
    install -D -t "$out/share/applications" ${finalAttrs.desktopItem}/share/applications/*
  '';

  meta = {
    description = "Eclipse-based LDAP browser and directory client";
    homepage = "https://directory.apache.org/studio/";
    sourceProvenance = with lib.sourceTypes; [
      binaryBytecode
      binaryNativeCode
    ];
    license = lib.licenses.asl20;
    # Upstream supports macOS and Windows too.
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
    mainProgram = "ApacheDirectoryStudio";
  };
})
