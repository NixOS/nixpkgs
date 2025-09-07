{
  lib,
  stdenv,
  buildPackages,
  copyDesktopItems,
  fetchzip,
  makeDesktopItem,
  makeWrapper,
  adwaita-icon-theme,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cacert,
  cairo,
  cups,
  curlWithGnuTls,
  dbus,
  e2fsprogs,
  expat,
  fontconfig,
  freetype,
  gdk-pixbuf,
  git,
  glib,
  gtk3,
  krb5,
  libGL,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libdrm,
  libgbm,
  libgnome-keyring,
  libuuid,
  libxcb,
  libxkbcommon,
  libxkbfile,
  libxshmfence,
  nspr,
  nss,
  openssl,
  pango,
  udev,
  unzip,
  zlib,
}:

let
  pname = "gitkraken";
  version = "11.3.0";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchzip {
      url = "https://api.gitkraken.dev/releases/production/linux/x64/${version}/gitkraken-amd64.tar.gz";
      hash = "sha256-OUPsDr7+aQfYO8Xdu7gHlx4gvOUH5ee9xPxEsD9s3ng=";
    };

    x86_64-darwin = fetchzip {
      url = "https://api.gitkraken.dev/releases/production/darwin/x64/${version}/GitKraken-v${version}.zip";
      hash = "sha256-J1RCFhIhi1z0WJ/a6z/KbSBJrhAiHFdBzy8EfZu6I6Y=";
    };

    aarch64-darwin = fetchzip {
      url = "https://api.gitkraken.dev/releases/production/darwin/arm64/${version}/GitKraken-v${version}.zip";
      hash = "sha256-hE0OOmDWlUBYBKMKLKDBO7FGoxwpLAb2lRkwCjFEAGE=";
    };
  };

  src = srcs.${stdenv.hostPlatform.system} or throwSystem;

  meta = {
    homepage = "https://www.gitkraken.com/git-client";
    description = "Simplifying Git for any OS";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with lib.maintainers; [
      nicolas-goudry
      Rishik-Y
    ];
    mainProgram = "gitkraken";
  };

  passthru.updateScript = ./update.sh;

  linux = stdenv.mkDerivation rec {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    dontBuild = true;
    dontConfigure = true;

    libPath = lib.makeLibraryPath [
      stdenv.cc.cc
      curlWithGnuTls
      udev
      libX11
      libXext
      libXcursor
      libXi
      libxcb
      glib
      libXScrnSaver
      libxkbfile
      libXtst
      nss
      nspr
      cups
      alsa-lib
      expat
      gdk-pixbuf
      dbus
      libXdamage
      libXrandr
      atk
      pango
      cairo
      freetype
      fontconfig
      libXcomposite
      libXfixes
      libXrender
      gtk3
      libgnome-keyring
      openssl
      at-spi2-atk
      at-spi2-core
      libuuid
      e2fsprogs
      krb5
      libdrm
      libgbm
      libxshmfence
      libxkbcommon
      libGL
      zlib
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "GitKraken Desktop";
        exec = "gitkraken";
        icon = "gitkraken";
        desktopName = "GitKraken Desktop";
        genericName = "Git Client";
        categories = [ "Development" ];
        comment = "Unleash your repo";
      })
    ];

    nativeBuildInputs = [
      copyDesktopItems
      # override doesn't preserve splicing https://github.com/NixOS/nixpkgs/issues/132651
      # Has to use `makeShellWrapper` from `buildPackages` even though `makeShellWrapper` from the inputs is spliced because `propagatedBuildInputs` would pick the wrong one because of a different offset.
      (buildPackages.wrapGAppsHook3.override { makeWrapper = buildPackages.makeShellWrapper; })
    ];
    buildInputs = [
      gtk3
      adwaita-icon-theme
    ];

    # avoid double-wrapping
    dontWrapGApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/${pname}/
      cp -R $src/* $out/share/${pname}

      mkdir -p $out/share/pixmaps
      cp gitkraken.png $out/share/pixmaps/

      runHook postInstall
    '';

    preFixup = ''
      gappsWrapperArgs+=(--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}")
    '';

    postFixup = ''
      pushd $out/share/${pname}
      for file in gitkraken chrome-sandbox chrome_crashpad_handler; do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $file
      done

      for file in $(find . -type f \( -name \*.node -o -name gitkraken -o -name git -o -name git-\* -o -name scalar -o -name \*.so\* \) ); do
        patchelf --set-rpath ${libPath}:$out/share/${pname} $file || true
      done
      popd

      # SSL and permissions fix for bundled nodegit
      pushd $out/share/${pname}/resources/app.asar.unpacked/node_modules/@axosoft/nodegit/build/Release
      mv nodegit-ubuntu-20.node nodegit-ubuntu-20-ssl-1.1.1.node
      mv nodegit-ubuntu-20-ssl-static.node nodegit-ubuntu-20.node
      chmod 755 nodegit-ubuntu-20.node
      popd

      # Devendor bundled git
      rm -rf $out/share/${pname}/resources/app.asar.unpacked/git
      ln -s ${git} $out/share/${pname}/resources/app.asar.unpacked/git

      # GitKraken expects the CA bundle to be located in the bundled git directory. Since we replace it with
      # the one from nixpkgs, which doesn't provide a CA bundle, we need to explicitly set its location at runtime
      makeWrapper $out/share/${pname}/gitkraken $out/bin/gitkraken \
        --set GIT_SSL_CAINFO "${cacert}/etc/ssl/certs/ca-bundle.crt" \
        "''${gappsWrapperArgs[@]}"
    '';
  };

  darwin = stdenv.mkDerivation {
    inherit
      pname
      version
      src
      meta
      passthru
      ;

    nativeBuildInputs = [
      unzip
      makeWrapper
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/Applications/GitKraken.app $out/bin
      cp -R . $out/Applications/GitKraken.app

      makeWrapper $out/Applications/GitKraken.app/Contents/MacOS/GitKraken $out/bin/gitkraken

      runHook postInstall
    '';

    dontFixup = true;
  };
in
if stdenv.hostPlatform.isDarwin then darwin else linux
