{
  channel,
  pname,
  version,
  sources,
  meta,
}:

{
  androidenv,
  fetchurl,
  lib,
  makeWrapper,
  runCommand,
  runtimeShell,
  stdenvNoCC,
  undmg,
}:

let
  source = sources.${stdenvNoCC.hostPlatform.system};
  appName =
    {
      stable = "Android Studio.app";
      beta = "Android Studio Preview Beta.app";
      canary = "Android Studio Preview Canary.app";
      dev = "Android Studio Preview Dev.app";
    }
    .${channel};

  androidStudio = stdenvNoCC.mkDerivation {
    pname = "${pname}-unwrapped";
    inherit version;

    src = fetchurl {
      inherit (source) url;
      sha256 = source.sha256Hash;
    };

    nativeBuildInputs = [
      makeWrapper
      undmg
    ];

    sourceRoot = ".";
    dontFixup = true;

    installPhase = ''
      runHook preInstall

      shopt -s nullglob
      apps=( *.app )
      if (( ''${#apps[@]} != 1 )); then
        echo "expected exactly one app bundle, found ''${#apps[@]}" >&2
        exit 1
      fi

      mkdir -p "$out/Applications/${appName}" "$out/bin"
      cp -R "''${apps[0]}/." "$out/Applications/${appName}"
      /usr/bin/xattr -cr "$out/Applications/${appName}"
      makeWrapper \
        "$out/Applications/${appName}/Contents/MacOS/studio" \
        "$out/bin/studio"

      runHook postInstall
    '';

    meta.mainProgram = "studio";
  };

  mkAndroidStudioWrapper =
    {
      androidStudio,
      androidSdk ? null,
    }:
    runCommand "${pname}-${version}"
      {
        inherit pname version;
        dontFixup = true;
        startScript =
          let
            hasAndroidSdk = androidSdk != null;
            androidHome = lib.optionalString hasAndroidSdk "${androidSdk}/libexec/android-sdk";
          in
          ''
            #!${runtimeShell}
            ${lib.optionalString hasAndroidSdk ''
              echo "=== nixpkgs Android Studio wrapper" >&2

              # Default ANDROID_HOME to the packaged one, if not provided.
              ANDROID_HOME="''${ANDROID_HOME-${androidHome}}"

              if [ -d "$ANDROID_HOME" ]; then
                export ANDROID_HOME
                echo "  - ANDROID_HOME=$ANDROID_HOME" >&2

                # Legacy compatibility.
                export ANDROID_SDK_ROOT="$ANDROID_HOME"

                # See if we can export ANDROID_NDK_ROOT too.
                ANDROID_NDK_ROOT="$ANDROID_SDK_ROOT/ndk-bundle"
                if [ ! -d "$ANDROID_NDK_ROOT" ]; then
                  ANDROID_NDK_ROOT="$(ls "$ANDROID_SDK_ROOT/ndk/"* 2>/dev/null | head -n1)"
                fi

                if [ -d "$ANDROID_NDK_ROOT" ]; then
                  export ANDROID_NDK_ROOT
                  echo "  - ANDROID_NDK_ROOT=$ANDROID_NDK_ROOT" >&2
                else
                  unset ANDROID_NDK_ROOT
                fi
              else
                unset ANDROID_HOME
                unset ANDROID_SDK_ROOT
              fi
            ''}
            exec "${androidStudio}/Applications/${appName}/Contents/MacOS/studio" "$@"
          '';
        preferLocalBuild = true;
        allowSubstitutes = false;
        passthru =
          let
            withSdk = androidSdk: mkAndroidStudioWrapper { inherit androidStudio androidSdk; };
          in
          {
            unwrapped = androidStudio;
            full = withSdk androidenv.androidPkgs.androidsdk;
            inherit withSdk;
            sdk = androidSdk;
            updateScript = [
              ./update.sh
              "${channel}"
            ];
          };
        inherit meta;
      }
      ''
        appDir="$out/Applications/${appName}/Contents"
        unwrappedAppDir="${androidStudio}/Applications/${appName}/Contents"

        mkdir -p "$appDir/MacOS" "$appDir/Resources" "$out/bin"
        cp "$unwrappedAppDir/Info.plist" "$appDir/Info.plist"
        cp "$unwrappedAppDir/Resources/"*.icns "$appDir/Resources/"

        echo -n "$startScript" > "$appDir/MacOS/studio"
        chmod +x "$appDir/MacOS/studio"
        ln -s "../Applications/${appName}/Contents/MacOS/studio" "$out/bin/${pname}"

        /usr/bin/codesign --force --sign - "$out/Applications/${appName}"
      '';
in
mkAndroidStudioWrapper { inherit androidStudio; }
