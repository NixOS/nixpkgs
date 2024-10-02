{
  lib,
  stdenv,
  libXcomposite,
  libgnome-keyring,
  makeWrapper,
  udev,
  curlWithGnuTls,
  alsa-lib,
  libXfixes,
  atk,
  gtk3,
  libXrender,
  pango,
  adwaita-icon-theme,
  cairo,
  freetype,
  fontconfig,
  libX11,
  libXi,
  libxcb,
  libXext,
  libXcursor,
  glib,
  libXScrnSaver,
  libxkbfile,
  libXtst,
  nss,
  nspr,
  cups,
  fetchzip,
  expat,
  gdk-pixbuf,
  libXdamage,
  libXrandr,
  dbus,
  makeDesktopItem,
  openssl,
  wrapGAppsHook3,
  buildPackages,
  at-spi2-atk,
  at-spi2-core,
  libuuid,
  e2fsprogs,
  krb5,
  libdrm,
  mesa,
  unzip,
  copyDesktopItems,
  libxshmfence,
  libxkbcommon,
  git,
  libGL,
  zlib,
  cacert,
}:

let
  pname = "gitkraken";
  version = "10.4.0";

  throwSystem = throw "Unsupported system: ${stdenv.hostPlatform.system}";

  srcs = {
    x86_64-linux = fetchzip {
      url = "https://release.axocdn.com/linux/GitKraken-v${version}.tar.gz";
      hash = "sha256-JGWDOAkJEnhvUyQOFsmoeW9Izj0IuHNpYGlYAMiWPj0=";
    };

    x86_64-darwin = fetchzip {
      url = "https://release.axocdn.com/darwin/GitKraken-v${version}.zip";
      hash = "sha256-yCDE6QJMgU2Mgr/kUDnbKwQ3MpgVcdjAK7fnTAjSL54=";
    };

    aarch64-darwin = fetchzip {
      url = "https://release.axocdn.com/darwin-arm64/GitKraken-v${version}.zip";
      hash = "sha256-nh+tO++QvPx9jyZuxNrH7rHFXZqVnu5jyiki3oWdw7E=";
    };
  };

  src = srcs.${stdenv.hostPlatform.system} or throwSystem;

  meta = with lib; {
    homepage = "https://www.gitkraken.com/git-client";
    description = "Simplifying Git for any OS";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = builtins.attrNames srcs;
    maintainers = with maintainers; [
      xnwdd
      evanjs
      arkivm
      nicolas-goudry
    ];
    mainProgram = "gitkraken";
  };

  linux = stdenv.mkDerivation rec {
    inherit
      pname
      version
      src
      meta
      ;

    dontBuild = true;
    dontConfigure = true;

    libPath = lib.makeLibraryPath [
      stdenv.cc.cc.lib
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
      mesa
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
      gappsWrapperArgs+=(--add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}")
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
      mv nodegit-ubuntu-18.node nodegit-ubuntu-18-ssl-1.1.1.node
      mv nodegit-ubuntu-18-ssl-static.node nodegit-ubuntu-18.node
      chmod 755 nodegit-ubuntu-18.node
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
