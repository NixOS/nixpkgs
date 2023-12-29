{ lib
, callPackage
, runCommand
, makeWrapper
, wrapGAppsHook
, fetchDartDeps
, buildDartApplication
, cacert
, glib
, flutter
}:

# absolutely no mac support for now

{ pubGetScript ? "flutter pub get"
, flutterBuildFlags ? [ ]
, extraWrapProgramArgs ? ""
, ...
}@args:

(buildDartApplication.override {
  dart = flutter;
  fetchDartDeps = fetchDartDeps.override { dart = flutter; };
}) (args // {
  sdkSetupScript = ''
    # Pub needs SSL certificates. Dart normally looks in a hardcoded path.
    # https://github.com/dart-lang/sdk/blob/3.1.0/runtime/bin/security_context_linux.cc#L48
    #
    # Dart does not respect SSL_CERT_FILE...
    # https://github.com/dart-lang/sdk/issues/48506
    # ...and Flutter does not support --root-certs-file, so the path cannot be manually set.
    # https://github.com/flutter/flutter/issues/56607
    # https://github.com/flutter/flutter/issues/113594
    #
    # libredirect is of no use either, as Flutter does not pass any
    # environment variables (including LD_PRELOAD) to the Pub process.
    #
    # Instead, Flutter is patched to allow the path to the Dart binary used for
    # Pub commands to be overriden.
    export NIX_FLUTTER_PUB_DART="${runCommand "dart-with-certs" { nativeBuildInputs = [ makeWrapper ]; } ''
      mkdir -p "$out/bin"
      makeWrapper ${flutter.dart}/bin/dart "$out/bin/dart" \
        --add-flags "--root-certs-file=${cacert}/etc/ssl/certs/ca-bundle.crt"
    ''}/bin/dart"

    export HOME="$NIX_BUILD_TOP"
    flutter config --no-analytics &>/dev/null # mute first-run
    flutter config --enable-linux-desktop >/dev/null
  '';

  inherit pubGetScript;

  nativeBuildInputs = (args.nativeBuildInputs or [ ]) ++ [ wrapGAppsHook ];
  buildInputs = (args.buildInputs or [ ]) ++ [ glib ];

  dontDartBuild = true;
  buildPhase = args.buildPhase or ''
    runHook preBuild

    mkdir -p build/flutter_assets/fonts

    doPubGet flutter pub get --offline -v
    flutter build linux -v --release --split-debug-info="$debug" ${builtins.concatStringsSep " " (map (flag: "\"${flag}\"") flutterBuildFlags)}

    runHook postBuild
  '';

  dontDartInstall = true;
  installPhase = args.installPhase or ''
    runHook preInstall

    built=build/linux/*/release/bundle

    mkdir -p $out/bin
    mv $built $out/app

    for f in $(find $out/app -iname "*.desktop" -type f); do
      install -D $f $out/share/applications/$(basename $f)
    done

    for f in $(find $out/app -maxdepth 1 -type f); do
      ln -s $f $out/bin/$(basename $f)
    done

    # make *.so executable
    find $out/app -iname "*.so" -type f -exec chmod +x {} +

    # remove stuff like /build/source/packages/ubuntu_desktop_installer/linux/flutter/ephemeral
    for f in $(find $out/app -executable -type f); do
      if patchelf --print-rpath "$f" | grep /build; then # this ignores static libs (e,g. libapp.so) also
        echo "strip RPath of $f"
        newrp=$(patchelf --print-rpath $f | sed -r "s|/build.*ephemeral:||g" | sed -r "s|/build.*profile:||g")
        patchelf --set-rpath "$newrp" "$f"
      fi
    done

    runHook postInstall
  '';

  dontWrapGApps = true;
  extraWrapProgramArgs = ''
    ''${gappsWrapperArgs[@]} \
    ${extraWrapProgramArgs}
  '';
})
