# Linux-specific base builder.

{
  stdenv,
  lib,
  makeDesktopItem,
  makeWrapper,
  patchelf,
  writeText,
  coreutils,
  gnugrep,
  which,
  git,
  unzip,
  libsecret,
  libnotify,
  udev,
  e2fsprogs,
  python3,
  autoPatchelfHook,
  glibcLocales,
  fontconfig,
  libGL,
  libx11,

  jdk,
  vmopts ? null,
  forceWayland ? null,
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

      libdbm,
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
      finalExtraWrapperArgs =
        extraWrapperArgs
        ++ lib.optionals forceWayland [
          ''--add-flags "\''${WAYLAND_DISPLAY:+-Dawt.toolkit.name=WLToolkit}"''
        ];

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
        stdenv.cc.cc
        fontconfig
        libGL
        libx11
      ];

      nativeBuildInputs = nativeBuildInputs ++ [
        makeWrapper
        patchelf
        unzip
        autoPatchelfHook
      ];

      postPatch = ''
        rm -rf jbr
        # When using the IDE as a remote backend using gateway, it expects the jbr directory to contain the jdk
        ln -s ${jdk.home} jbr

        if [ -d "plugins/remote-dev-server" ]; then
          patch -F3 -p1 < ${../patches/jetbrains-remote-dev.patch}
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
            libsecret
            e2fsprogs
            libnotify
            # Required for Help -> Collect Logs
            # in at least rider and goland
            udev
          ]
        } >> $vmopts_file
      ''
      + postPatch;

      installPhase = ''
        runHook preInstall

        mkdir -p $out/{bin,$pname,share/pixmaps,share/icons/hicolor/scalable/apps}
        cp -a . $out/$pname
        [[ -f $out/$pname/bin/${loName}.png ]] && ln -s $out/$pname/bin/${loName}.png $out/share/pixmaps/${pname}.png
        [[ -f $out/$pname/bin/${loName}.svg ]] && ln -s $out/$pname/bin/${loName}.svg $out/share/pixmaps/${pname}.svg \
          && ln -s $out/$pname/bin/${loName}.svg $out/share/icons/hicolor/scalable/apps/${pname}.svg
        cp ${libdbm}/lib/libdbm.so $out/$pname/bin/libdbm.so
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
                jdk
                coreutils
                gnugrep
                which
                git
              ]
            }" \
            --suffix PATH : "${lib.makeBinPath [ python3 ]}" \
            --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extraLdPath}" \
            ${lib.concatStringsSep " " finalExtraWrapperArgs} \
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
        rm -rf $out/$pname/plugins/remote-dev-server/selfcontained/
        echo -e '#!/usr/bin/env bash\n'"$out/$pname/bin/remote-dev-server.sh"' "$@"' > $out/$pname/bin/remote-dev-server-wrapped.sh
        chmod +x $out/$pname/bin/remote-dev-server-wrapped.sh
        ln -s "$out/$pname/bin/remote-dev-server-wrapped.sh" $out/bin/$pname-remote-dev-server
        ln -s "$item/share/applications" $out/share

        runHook postInstall
      '';

      preferLocalBuild = !(finalAttrs.meta.license.free or true);

      meta = meta // {
        mainProgram = pname;
      };
    };
}
