{
  lib,
  callPackage,
  runCommand,
  makeWrapper,
  wrapGAppsHook3,
  buildDartApplication,
  cacert,
  glib,
  flutter,
  pkg-config,
  jq,
  yq,
  moreutils,
}:

# absolutely no mac support for now

{
  pubGetScript ? "flutter pub get",
  flutterBuildFlags ? [ ],
  targetFlutterPlatform ? "linux",
  extraWrapProgramArgs ? "",
  ...
}@args:

let
  builderArgs =
    rec {
      universal = args // {
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
          export NIX_FLUTTER_PUB_DART="${
            runCommand "dart-with-certs" { nativeBuildInputs = [ makeWrapper ]; } ''
              mkdir -p "$out/bin"
              makeWrapper ${flutter.dart}/bin/dart "$out/bin/dart" \
                --add-flags "--root-certs-file=${cacert}/etc/ssl/certs/ca-bundle.crt"
            ''
          }/bin/dart"

          export HOME="$NIX_BUILD_TOP"
          flutter config --no-analytics &>/dev/null # mute first-run
          flutter config --enable-linux-desktop >/dev/null
        '';

        inherit pubGetScript;

        sdkSourceBuilders = {
          # https://github.com/dart-lang/pub/blob/68dc2f547d0a264955c1fa551fa0a0e158046494/lib/src/sdk/flutter.dart#L81
          "flutter" =
            name:
            runCommand "flutter-sdk-${name}" { passthru.packageRoot = "."; } ''
              for path in '${flutter}/packages/${name}' '${flutter}/bin/cache/pkg/${name}'; do
                if [ -d "$path" ]; then
                  ln -s "$path" "$out"
                  break
                fi
              done

              if [ ! -e "$out" ]; then
                echo 1>&2 'The Flutter SDK does not contain the requested package: ${name}!'
                exit 1
              fi
            '';
        };

        extraPackageConfigSetup = ''
          # https://github.com/flutter/flutter/blob/3.13.8/packages/flutter_tools/lib/src/dart/pub.dart#L755
          if [ "$('${yq}/bin/yq' '.flutter.generate // false' pubspec.yaml)" = "true" ]; then
            '${jq}/bin/jq' '.packages |= . + [{
              name: "flutter_gen",
              rootUri: "flutter_gen",
              languageVersion: "2.12",
            }]' "$out" | '${moreutils}/bin/sponge' "$out"
          fi
        '';
      };

      linux = universal // {
        outputs = universal.outputs or [ ] ++ [ "debug" ];

        nativeBuildInputs = (universal.nativeBuildInputs or [ ]) ++ [
          wrapGAppsHook3

          # Flutter requires pkg-config for Linux desktop support, and many plugins
          # attempt to use it.
          #
          # It is available to the `flutter` tool through its wrapper, but it must be
          # added here as well so the setup hook adds plugin dependencies to the
          # pkg-config search paths.
          pkg-config
        ];

        buildInputs = (universal.buildInputs or [ ]) ++ [ glib ];

        dontDartBuild = true;
        buildPhase =
          universal.buildPhase or ''
            runHook preBuild

            mkdir -p build/flutter_assets/fonts

            flutter build linux -v --release --split-debug-info="$debug" ${
              builtins.concatStringsSep " " (map (flag: "\"${flag}\"") flutterBuildFlags)
            }

            runHook postBuild
          '';

        dontDartInstall = true;
        installPhase =
          universal.installPhase or ''
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
      };

      web = universal // {
        dontDartBuild = true;
        buildPhase =
          universal.buildPhase or ''
            runHook preBuild

            mkdir -p build/flutter_assets/fonts

            flutter build web -v --release ${
              builtins.concatStringsSep " " (map (flag: "\"${flag}\"") flutterBuildFlags)
            }

            runHook postBuild
          '';

        dontDartInstall = true;
        installPhase =
          universal.installPhase or ''
            runHook preInstall

            cp -r build/web "$out"

            runHook postInstall
          '';
      };
    }
    .${targetFlutterPlatform} or (throw "Unsupported Flutter host platform: ${targetFlutterPlatform}");

  minimalFlutter = flutter.override {
    supportedTargetFlutterPlatforms = [
      "universal"
      targetFlutterPlatform
    ];
  };

  buildAppWith = flutter: buildDartApplication.override { dart = flutter; };
in
buildAppWith minimalFlutter (
  builderArgs
  // {
    passthru = builderArgs.passthru or { } // {
      multiShell = buildAppWith flutter builderArgs;
    };
  }
)
