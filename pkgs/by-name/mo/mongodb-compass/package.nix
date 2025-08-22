{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  unzip,
  wrapGAppsHook3,
  makeWrapper,
  runtimeShell,
  gtk3,
  xorg,
  glib,
  cairo,
  pango,
  dbus,
  cups,
  at-spi2-atk,
  at-spi2-core,
  atk,
  libdrm,
  gdk-pixbuf,
  nss,
  nspr,
  alsa-lib,
  expat,
  libxkbcommon,
  libgbm,
  vulkan-loader,
  systemd,
  libGL,
  krb5,
  fontconfig,
  freetype,
  libnotify,
  libsecret,
  libuuid,
  libxcb,
  patchelf,
}:

let
  pname = "mongodb-compass";
  version = "1.46.11";

  selectSystem =
    attrs:
    attrs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://downloads.mongodb.com/compass/${
      selectSystem {
        x86_64-linux = "mongodb-compass_${version}_amd64.deb";
        x86_64-darwin = "mongodb-compass-${version}-darwin-x64.zip";
        aarch64-darwin = "mongodb-compass-${version}-darwin-arm64.zip";
      }
    }";
    hash = selectSystem {
      x86_64-linux = "sha256-GelQnhrc68xEd4q4ZPgldCnbuLqYZ76LQbWi1LsvL9o=";
      x86_64-darwin = "sha256-SiwwK7ApifjvCqBeVPtjnafKLKETnP8tegVfXaiCJ8c=";
      aarch64-darwin = "sha256-g2X9zOk7rjuTFxXXX8t9kvjF11VknlIvjAhYU09fjBQ=";
    };
  };

  appName = "MongoDB Compass.app";

  rpath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libGL
    libnotify
    libsecret
    libuuid
    libxcb
    libxkbcommon
    libgbm
    nspr
    nss
    pango
    stdenv.cc.cc
    systemd
    xorg.libX11
    xorg.libXScrnSaver
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxkbfile
    xorg.libxshmfence
    (lib.getLib stdenv.cc.cc)
  ];
in
stdenv.mkDerivation (finalAttrs: {
  inherit pname version src;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    dpkg
    wrapGAppsHook3
    patchelf
  ];

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ unzip ];

  dontUnpack = stdenv.hostPlatform.isLinux;
  dontFixup = stdenv.hostPlatform.isDarwin;
  sourceRoot = lib.optionalString stdenv.hostPlatform.isDarwin appName;

  buildCommand = lib.optionalString stdenv.hostPlatform.isLinux ''
    IFS=$'\n'

    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile $src | tar --extract

    mkdir -p $out
    mv usr/* $out

    rm -rf $out/share/lintian

    # The node_modules are bringing in non-linux files/dependencies
    find $out -name "*.app" -exec rm -rf {} \; || true
    find $out -name "*.dll" -delete
    find $out -name "*.exe" -delete

    # Otherwise it looks "suspicious"
    chmod -R g-w $out

    for file in `find $out -type f -perm /0111 -o -name \*.so\*`; do
      echo "Manipulating file: $file"
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" "$file" || true
      patchelf --set-rpath ${rpath}:$out/lib/mongodb-compass "$file" || true
    done

    wrapGAppsHook $out/bin/mongodb-compass
  '';

  installPhase = ''
    runHook preInstall

    ${lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Create directories for the application bundle and the launcher script.
      mkdir -p "$out/Applications/${appName}" "$out/bin"

      # Copy the unzipped app bundle into the Applications folder.
      cp -R . "$out/Applications/${appName}"

      # Create a launcher script that opens the app.
      cat > "$out/bin/${pname}" << EOF
      #!${runtimeShell}
      open -na "$out/Applications/${appName}" --args "\$@"
      EOF
      chmod +x "$out/bin/${pname}"
    ''}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "GUI for MongoDB";
    homepage = "https://github.com/mongodb-js/compass";
    license = lib.licenses.sspl;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "mongodb-compass";
    maintainers = with lib.maintainers; [
      bryanasdev000
      friedow
      iamanaws
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
  };
})
