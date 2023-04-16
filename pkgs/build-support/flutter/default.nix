{ lib
, callPackage
, stdenvNoCC
, llvmPackages_13
, cacert
, flutter
, git
}:

# absolutely no mac support for now

{ pubGetScript ? "flutter pub get"
, flutterBuildFlags ? []
, vendorHash
, pubspecLockFile ? null
, nativeBuildInputs ? [ ]
, ...
}@args:
let
  flutterSetupScript = ''
    export HOME="$NIX_BUILD_TOP"
    flutter config --no-analytics &>/dev/null # mute first-run
    flutter config --enable-linux-desktop >/dev/null
  '';

  deps = callPackage ../dart/fetch-dart-deps { dart = flutter; } {
    sdkSetupScript = flutterSetupScript;
    inherit pubGetScript vendorHash pubspecLockFile;
    buildDrvArgs = args;
  };
  self =
(self: llvmPackages_13.stdenv.mkDerivation (args // {
  outputs = [ "out" "debug" ];

  nativeBuildInputs = [
    deps
    flutter
    git
  ] ++ nativeBuildInputs;

  configurePhase = ''
    runHook preConfigure

    ${flutterSetupScript}

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    mkdir -p build/flutter_assets/fonts

    flutter packages get --offline -v
    flutter build linux -v --release --split-debug-info="$debug" ${builtins.concatStringsSep " " (map (flag: "\"${flag}\"") flutterBuildFlags)}

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
})) self;
in
  self
