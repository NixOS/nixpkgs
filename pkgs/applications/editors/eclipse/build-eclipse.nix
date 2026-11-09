{
  lib,
  stdenv,
  makeDesktopItem,
  freetype,
  fontconfig,
  libx11,
  libxrender,
  zlib,
  jdk,
  glib,
  glib-networking,
  gtk,
  libxtst,
  libsecret,
  gsettings-desktop-schemas,
  webkitgtk_4_1,
  makeWrapper,
  perl,
  cacert,
  jre-generate-cacerts,
  ...
}:

{
  pname,
  src ? builtins.getAttr stdenv.hostPlatform.system sources,
  sources ? null,
  description,
  version,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  desktopItem = makeDesktopItem {
    name = "Eclipse";
    exec = "eclipse";
    icon = "eclipse";
    comment = "Integrated Development Environment";
    desktopName = "Eclipse IDE";
    genericName = "Integrated Development Environment";
    categories = [ "Development" ];
  };

  nativeBuildInputs = [
    makeWrapper
    perl
  ];
  buildInputs = [
    fontconfig
    freetype
    glib
    gsettings-desktop-schemas
    gtk
    jdk
    libx11
    libxrender
    libxtst
    libsecret
    zlib
  ]
  ++ lib.optional (webkitgtk_4_1 != null) webkitgtk_4_1;

  buildCommand = ''
    # Unpack tarball.
    mkdir -p $out
    tar xfvz $src -C $out

    # Patch binaries.
    interpreter="$(cat $NIX_BINTOOLS/nix-support/dynamic-linker)"
    libCairo=$out/eclipse/libcairo-swt.so
    patchelf --set-interpreter $interpreter $out/eclipse/eclipse
    [ -f $libCairo ] && patchelf --set-rpath ${
      lib.makeLibraryPath [
        freetype
        fontconfig
        libx11
        libxrender
        zlib
      ]
    } $libCairo

    # Create wrapper script.  Pass -configuration to store
    # settings in ~/.eclipse/org.eclipse.platform_<version> rather
    # than ~/.eclipse/org.eclipse.platform_<version>_<number>.
    productId=$(sed 's/id=//; t; d' $out/eclipse/.eclipseproduct)

    makeWrapper $out/eclipse/eclipse $out/bin/eclipse \
      --prefix PATH : ${jdk}/bin \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (
          [
            glib
            gtk
            libxtst
            libsecret
          ]
          ++ lib.optional (webkitgtk_4_1 != null) webkitgtk_4_1
        )
      } \
      --prefix GIO_EXTRA_MODULES : "${glib-networking}/lib/gio/modules" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH" \
      --add-flags "-configuration \$HOME/.eclipse/''${productId}_${version}/configuration"

    # Create desktop item.
    mkdir -p $out/share/applications
    cp ${finalAttrs.desktopItem}/share/applications/* $out/share/applications
    mkdir -p $out/share/pixmaps
    ln -s $out/eclipse/icon.xpm $out/share/pixmaps/eclipse.xpm

    # ensure eclipse.ini does not try to use a justj jvm, as those aren't compatible with nix
    perl -i -p0e 's|-vm\nplugins/org.eclipse.justj.*/jre/bin.*\n||' $out/eclipse/eclipse.ini
  ''
  # regenerate the bundled JustJ JRE's CA keystore from cacert, as openjdk does
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    for cacerts in $out/eclipse/plugins/org.eclipse.justj.openjdk.*/jre/lib/security/cacerts; do
      [ -e "$cacerts" ] || continue
      (
        cd "$(dirname "$cacerts")"
        rm cacerts
        JAVA_TOOL_OPTIONS="-Dkeystore.pkcs12.certProtectionAlgorithm=NONE -Dkeystore.pkcs12.macAlgorithm=NONE" \
          ${jre-generate-cacerts} ${jdk}/bin/keytool ${cacert}/etc/ssl/certs/ca-bundle.crt
      )
    done
  ''; # */

  passthru.updateScript = ./update.sh;

  meta = {
    homepage = "https://www.eclipse.org/";
    inherit description;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ lib.maintainers.jerith666 ];
  };
})
