# Linux-specific base builder.

{
  # keep-sorted start
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  autoPatchelfHook,
  cairo,
  coreutils,
  cups,
  dbus,
  e2fsprogs,
  fontconfig,
  git,
  glibcLocales,
  gnugrep,
  lib,
  libGL,
  libgbm,
  libnotify,
  libsecret,
  libx11,
  libxcb,
  libxcomposite,
  libxdamage,
  libxext,
  libxfixes,
  libxkbcommon,
  libxrandr,
  makeDesktopItem,
  makeWrapper,
  nspr,
  nss,
  pango,
  patchelf,
  python3,
  stdenv,
  udev,
  unzip,
  which,
  writeText,
  # keep-sorted end

  vmopts ? null,
  excludeDrvArgNames,
}:

lib.extendMkDerivation {
  inherit excludeDrvArgNames;

  constructDrv = stdenv.mkDerivation;

  extendDrvArgs =
    finalAttrs:
    {
      pname,
      product,
      productShort ? product,
      wmClass,

      jdk,
      jetbrains-libdbm,
      fsnotifier,

      extraLdPath ? [ ],
      extraWrapperArgs ? [ ],
      buildInputs ? [ ],
      nativeBuildInputs ? [ ],
      meta ? { },
      postPatch ? "",
      ...
    }:

    let
      loName = lib.toLower productShort;
      hiName = lib.toUpper productShort;
      vmoptsName = loName + lib.optionalString stdenv.hostPlatform.is64bit "64" + ".vmoptions";

      desktopItem = makeDesktopItem {
        name = finalAttrs.pname;
        exec = finalAttrs.meta.mainProgram;
        comment = lib.trim (lib.replaceString "\n" " " finalAttrs.meta.longDescription);
        desktopName = product;
        genericName = finalAttrs.meta.description;
        categories = [ "Development" ];
        icon = pname;
        startupWMClass = wmClass;
      };

      vmoptsIDE = if hiName == "WEBSTORM" then "WEBIDE" else hiName;
      vmoptsFile = lib.optionalString (vmopts != null) (writeText vmoptsName vmopts);
    in
    {
      inherit desktopItem vmoptsIDE vmoptsFile;

      buildInputs = buildInputs ++ [
        # keep-sorted start
        alsa-lib
        at-spi2-atk
        at-spi2-core
        atk
        cairo
        cups
        dbus
        fontconfig
        libGL
        libgbm
        libx11
        libxcb
        libxcomposite
        libxdamage
        libxext
        libxfixes
        libxkbcommon
        libxrandr
        nspr
        nss
        pango
        stdenv.cc.cc
        udev
        # keep-sorted end
      ];

      nativeBuildInputs = nativeBuildInputs ++ [
        # keep-sorted start
        autoPatchelfHook
        makeWrapper
        patchelf
        unzip
        # keep-sorted end
      ];

      postPatch = ''
        rm -rf jbr
        # When using the IDE as a remote backend using gateway, it expects the jbr directory to contain the jdk
        ln -s ${jdk.home} jbr

        if [ -d "plugins/remote-dev-server" ]; then
          patch -F3 -p1 < ${../patches/jetbrains-remote-dev.patch}
        fi

        # The bundled libraries of the remote dev server are not used (see the patch above),
        # so drop them. This has to happen before autoPatchelfHook runs, otherwise their
        # directory ends up in the RPATH of unrelated binaries, see below.
        rm -rf plugins/remote-dev-server/selfcontained

        # libjcef.so has "." in its RPATH. autoPatchelfHook follows the RPATHs of the
        # libraries it indexes and resolves that "." against the build directory, which
        # makes it prefer bundled copies of libraries over the ones from nixpkgs and
        # bake build-time-only paths into the RPATHs it writes.
        if [ -e plugins/jcef-plugin/jcef/libjcef.so ]; then
          patchelf --set-rpath '$ORIGIN' plugins/jcef-plugin/jcef/libjcef.so
        fi

        vmopts_file=bin/linux/${vmoptsName}
        if [[ ! -f $vmopts_file ]]; then
          vmopts_file=bin/${vmoptsName}
          if [[ ! -f $vmopts_file ]]; then
            echo "ERROR: $vmopts_file not found"
            exit 1
          fi
        fi
        echo -Djna.library.path=${
          lib.makeLibraryPath [
            e2fsprogs
            libnotify
            libsecret
            udev
          ]
        } >> $vmopts_file
      ''
      + postPatch;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,$pname,share/icons/hicolor/scalable/apps,share/icons/hicolor/128x128/apps}
        cp -a . $out/$pname
        [[ -f $out/$pname/bin/${loName}.png ]] && ln -s $out/$pname/bin/${loName}.png $out/share/icons/hicolor/128x128/apps/${pname}.png
        [[ -f $out/$pname/bin/${loName}.svg ]] && ln -s $out/$pname/bin/${loName}.svg $out/share/icons/hicolor/scalable/apps/${pname}.svg
        cp ${jetbrains-libdbm}/lib/libdbm.so $out/$pname/bin/libdbm.so
        cp ${fsnotifier}/bin/fsnotifier $out/$pname/bin/fsnotifier

        jdk=${jdk.home}
        item=${desktopItem}

        needsWrapping=()

        if [ -f "$out/$pname/bin/${loName}" ]; then
          needsWrapping+=("$out/$pname/bin/${loName}")
        fi
        if [ -f "$out/$pname/bin/${loName}.sh" ]; then
          needsWrapping+=("$out/$pname/bin/${loName}.sh")
        fi

        for launcher in "''${needsWrapping[@]}"
        do
          wrapProgram  "$launcher" \
            --prefix PATH : "${
              lib.makeBinPath [
                coreutils
                git
                gnugrep
                jdk
                which
              ]
            }" \
            --suffix PATH : "${lib.makeBinPath [ python3 ]}" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extraLdPath}" \
            ${lib.concatStringsSep " " extraWrapperArgs} \
            --set-default JDK_HOME "$jdk" \
            --set-default ANDROID_JAVA_HOME "$jdk" \
            --set-default JAVA_HOME "$jdk" \
            --set-default JETBRAINS_CLIENT_JDK "$jdk" \
            --set-default ${hiName}_JDK "$jdk" \
            --set-default LOCALE_ARCHIVE "${glibcLocales}/lib/locale/locale-archive" \
            --set-default ${vmoptsIDE}_VM_OPTIONS ${vmoptsFile}
        done

        launcher="$out/$pname/bin/${loName}"
        if [ ! -e "$launcher" ]; then
          launcher+=.sh
        fi

        ln -s "$launcher" $out/bin/$pname
        echo -e '#!/usr/bin/env bash\n'"$out/$pname/bin/remote-dev-server.sh"' "$@"' > $out/$pname/bin/remote-dev-server-wrapped.sh
        chmod +x $out/$pname/bin/remote-dev-server-wrapped.sh
        ln -s "$out/$pname/bin/remote-dev-server-wrapped.sh" $out/bin/$pname-remote-dev-server
        ln -s "$item/share/applications" $out/share

        runHook postInstall
      '';

      preFixup = ''
        addAutoPatchelfSearchPath "${jdk.home}/lib"
      '';

      preferLocalBuild = !(finalAttrs.meta.license.free or true);

      meta = meta // {
        mainProgram = pname;
      };
    };
}
