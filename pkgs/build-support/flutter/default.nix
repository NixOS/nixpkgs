{ lib
, callPackage
, stdenvNoCC
, runCommand
, makeWrapper
, wrapGAppsHook
, llvmPackages_13
, cacert
, glib
, flutter
, jq
}:

# absolutely no mac support for now

{ pubGetScript ? "flutter pub get"
, flutterBuildFlags ? [ ]
, runtimeDependencies ? [ ]
, customPackageOverrides ? { }
, autoDepsList ? false
, depsListFile ? null
, vendorHash ? ""
, pubspecLockFile ? null
, nativeBuildInputs ? [ ]
, preUnpack ? ""
, postFixup ? ""
, extraWrapProgramArgs ? ""
, ...
}@args:
let
  flutterSetupScript = ''
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

  deps = callPackage ../dart/fetch-dart-deps { dart = flutter; } {
    sdkSetupScript = flutterSetupScript;
    inherit pubGetScript vendorHash pubspecLockFile;
    buildDrvArgs = args;
  };

  baseDerivation = llvmPackages_13.stdenv.mkDerivation (finalAttrs: args // {
    inherit flutterBuildFlags runtimeDependencies;

    outputs = [ "out" "debug" ];

    nativeBuildInputs = [
      makeWrapper
      deps
      flutter
      jq
      glib
      wrapGAppsHook
    ] ++ nativeBuildInputs;

    dontWrapGApps = true;

    preUnpack = ''
      ${lib.optionalString (!autoDepsList) ''
        if ! { [ '${lib.boolToString (depsListFile != null)}' = 'true' ] ${lib.optionalString (depsListFile != null) "&& cmp -s <(jq -Sc . '${depsListFile}') <(jq -Sc . '${finalAttrs.passthru.depsListFile}')"}; }; then
          echo 1>&2 -e '\nThe dependency list file was either not given or differs from the expected result.' \
                      '\nPlease choose one of the following solutions:' \
                      '\n - Duplicate the following file and pass it to the depsListFile argument.' \
                      '\n   ${finalAttrs.passthru.depsListFile}' \
                      '\n - Set autoDepsList to true (not supported by Hydra or permitted in Nixpkgs)'.
          exit 1
        fi
      ''}

      ${preUnpack}
    '';

    configurePhase = ''
      runHook preConfigure

      ${flutterSetupScript}

      runHook postConfigure
    '';

    buildPhase = ''
      runHook preBuild

      mkdir -p build/flutter_assets/fonts

      doPubGet flutter pub get --offline -v
      flutter build linux -v --release --split-debug-info="$debug" ${builtins.concatStringsSep " " (map (flag: "\"${flag}\"") finalAttrs.flutterBuildFlags)}

      runHook postBuild
    '';

    installPhase = ''
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

    postFixup = ''
      # Add runtime library dependencies to the LD_LIBRARY_PATH.
      # For some reason, the RUNPATH of the executable is not used to load dynamic libraries in dart:ffi with DynamicLibrary.open().
      #
      # This could alternatively be fixed with patchelf --add-needed, but this would cause all the libraries to be opened immediately,
      # which is not what application authors expect.
      for f in "$out"/bin/*; do
        wrapProgram "$f" \
          --suffix LD_LIBRARY_PATH : '${lib.makeLibraryPath finalAttrs.runtimeDependencies}' \
          ''${gappsWrapperArgs[@]} \
          ${extraWrapProgramArgs}
      done

      ${postFixup}
    '';

    passthru = (args.passthru or {}) // {
      inherit (deps) depsListFile;
    };
  });

  packageOverrideRepository = (callPackage ../../development/compilers/flutter/package-overrides { }) // customPackageOverrides;
  productPackages = builtins.filter (package: package.kind != "dev")
    (if autoDepsList
    then lib.importJSON deps.depsListFile
    else
      if depsListFile == null
      then [ ]
      else lib.importJSON depsListFile);
in
builtins.foldl'
  (prev: package:
  if packageOverrideRepository ? ${package.name}
  then
    prev.overrideAttrs
      (packageOverrideRepository.${package.name} {
        inherit (package)
          name
          version
          kind
          source
          dependencies;
      })
  else prev)
  baseDerivation
  productPackages
