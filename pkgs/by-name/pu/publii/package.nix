{
  stdenv,
  lib,
  fetchurl,
  nix-update-script,
  asar,
  autoPatchelfHook,
  makeShellWrapper,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus,
  expat,
  glib,
  glibc,
  gtk3,
  libsecret,
  libgbm,
  libGL,
  musl,
  nss,
  pango,
  udev,
  xdg-utils,
  libx11,
  libxcb,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "publii";
  version = "0.48.1";

  src = fetchurl {
    url = "https://getpublii.com/download/Publii-${finalAttrs.version}.deb";
    hash = "sha256-PUE0ZgazNwanmLmr3qd6t2eRJFQF9SwSMGQbuahu6oI=";
  };

  dontConfigure = true;
  dontBuild = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    asar
    autoPatchelfHook
    makeShellWrapper
    wrapGAppsHook3
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus
    expat
    glib
    glibc
    gtk3
    libsecret
    libgbm
    musl
    nss
    pango
    libx11
    libxcb
  ];

  unpackPhase = ''
    # A .deb is an ar archive. Only its data.tar.xz payload
    # (the files to install) is needed, not the control metadata.
    ar p $src data.tar.xz | tar xJ
  '';

  installPhase = ''
    runHook preInstall

    # Holds the Publii wrapper created by makeWrapper in preFixup.
    mkdir -p $out/bin

    # Desktop entry and icons.
    mv usr/share $out

    # Launch through the wrapper on PATH instead of the original /opt path.
    substituteInPlace $out/share/applications/Publii.desktop \
      --replace-fail 'Exec=/opt/Publii/Publii' 'Exec=Publii'

    # The prebuilt Electron app lives in /opt/Publii in the .deb; keep that
    # layout under $out so the wrapper in preFixup can point at it.
    mv opt $out

    # Publii copies bundled files (default theme, site templates, vendor
    # assets) into ~/Documents/Publii with fs-extra, which preserves the
    # read-only modes of the Nix store and leaves the copies unmodifiable.
    # Unpack the asar so fs-extra can be patched to always add u+w; Electron
    # loads resources/app when app.asar is absent.
    pushd $out/opt/Publii/resources
    asar extract app.asar app
    rm -r app.asar app.asar.unpacked
    substituteInPlace app/node_modules/fs-extra/lib/copy/copy-sync.js \
      --replace-fail 'return fs.chmodSync(dest, srcMode)' 'return fs.chmodSync(dest, srcMode | 0o200)'
    popd

    runHook postInstall
  '';

  preFixup = ''
    makeWrapper $out/opt/Publii/Publii $out/bin/Publii \
      "''${gappsWrapperArgs[@]}" \
      --suffix PATH : ${lib.makeBinPath [ xdg-utils ]} \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          libGL
          udev
        ]
      }
  '';

  meta = {
    description = "Static Site CMS with GUI to build privacy-focused SEO-friendly website";
    mainProgram = "Publii";
    longDescription = ''
      Creating a website doesn't have to be complicated or expensive. With Publii, the most
      intuitive static site CMS, you can create a beautiful, safe, and privacy-friendly website
      quickly and easily; perfect for anyone who wants a fast, secure website in a flash.
    '';
    homepage = "https://getpublii.com";
    changelog = "https://github.com/getpublii/publii/releases";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ amz-x ];
    platforms = [ "x86_64-linux" ];
  };
})
