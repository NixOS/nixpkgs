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
  vmopts ? null,
  glibcLocales,
}:

{
  pname,
  product,
  productShort ? product,
  version,
  src,
  wmClass,
  buildNumber,
  jdk,
  meta,
  libdbm,
  fsnotifier,
  extraLdPath ? [ ],
  extraWrapperArgs ? [ ],
  extraBuildInputs ? [ ],
  ...
}@args:

let
  loName = lib.toLower productShort;
  hiName = lib.toUpper productShort;
  vmoptsName = loName + lib.optionalString stdenv.hostPlatform.is64bit "64" + ".vmoptions";
in

with stdenv;
lib.makeOverridable mkDerivation (
  rec {
    inherit pname version src;
    passthru.buildNumber = buildNumber;
    passthru.tests = args.passthru.tests;
    meta = args.meta // {
      mainProgram = pname;
    };

    desktopItem = makeDesktopItem {
      name = pname;
      exec = pname;
      comment = lib.replaceStrings [ "\n" ] [ " " ] meta.longDescription;
      desktopName = product;
      genericName = meta.description;
      categories = [ "Development" ];
      icon = pname;
      startupWMClass = wmClass;
    };

    vmoptsIDE = if hiName == "WEBSTORM" then "WEBIDE" else hiName;
    vmoptsFile = lib.optionalString (vmopts != null) (writeText vmoptsName vmopts);

    nativeBuildInputs = [
      makeWrapper
      patchelf
      unzip
      autoPatchelfHook
    ];
    buildInputs = extraBuildInputs;

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
        lib.makeLibraryPath ([
          libsecret
          e2fsprogs
          libnotify
          # Required for Help -> Collect Logs
          # in at least rider and goland
          udev
        ])
      } >> $vmopts_file
    '';

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
      rm -rf $out/$pname/plugins/remote-dev-server/selfcontained/
      echo -e '#!/usr/bin/env bash\n'"$out/$pname/bin/remote-dev-server.sh"' "$@"' > $out/$pname/bin/remote-dev-server-wrapped.sh
      chmod +x $out/$pname/bin/remote-dev-server-wrapped.sh
      ln -s "$out/$pname/bin/remote-dev-server-wrapped.sh" $out/bin/$pname-remote-dev-server
      ln -s "$item/share/applications" $out/share

      runHook postInstall
    '';
  }
  // lib.optionalAttrs (!(meta.license.free or true)) {
    preferLocalBuild = true;
  }
)
