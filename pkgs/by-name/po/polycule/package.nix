{
  lib,
  flutter335,
  fetchFromGitLab,
  pkg-config,
  alsa-lib,
  mpv-unwrapped,

  targetFlutterPlatform ? "linux",

  # HACK we reuse fluffychat-web's vodozemac-wasm package here
  # TODO: dont, separate it out
  callPackage,
  polycule-web,
  vodozemac-wasm ? callPackage ../../fl/fluffychat/vodozemac-wasm.nix {
    fluffychat-web = polycule-web;
    flutter = flutter335;
  },
}:
flutter335.buildFlutterApplication (
  rec {
    pname = "polycule-${targetFlutterPlatform}";
    version = "0.3.4";

    src = fetchFromGitLab {
      owner = "polycule_client";
      repo = "polycule";
      tag = "v${version}";
      hash = "sha256-RUu8DKuX2NUU5Ce5WLHtDaORkn7CSrgTj3KhM/z+yHc=";
    };

    # yq pubspec.lock -o=json > pubspec.lock.json
    pubspecLock = lib.importJSON ./pubspec.lock.json;
    gitHashes = {
      matrix = "sha256-w/QB5nYJ9Lh77TcYKEN/DnNQjWfp+9NX0dwQ9GOzWE8=";
      media_kit = "sha256-3VtvM6brOhhx/lgPAzPcxe+I6zB0x7UWIhcEmk9krFc=";
      media_kit_libs_android_video = "sha256-nNKVF0kYOfP7ffqa/WPwATjaleB1QaJcT0aFMO7r+90=";
    };

    inherit targetFlutterPlatform;

    flutterBuildFlags = [
      "--dart-define=POLYCULE_IS_STABLE=true"
      "--dart-define=POLYCULE_VERSION=${version}"
      "--dart-define=cronetHttpNoPlay=true"
    ]
    ++ lib.optionals (targetFlutterPlatform == "linux") [
      "--dart-define=no_default_http_client=true"
    ]
    ++ lib.optionals (targetFlutterPlatform == "web") [
      "--native-null-assertions"
      "--dart-define=no_default_http_client=false"
      "--no-web-resources-cdn"
      "--source-maps"
    ];

    meta = {
      description = "Geeky and efficient [matrix] client for power users";
      longDescription = ''
        A geeky and efficient [matrix] client for power users.

        - **next-gen**\
          An OIDC-native, cutting-edge [matrix] client.

        - **accessible**\
          Development focussed on accessibility, screen reader support and semantic. Because we all matter.

        - **geeky**\
          Terminal style design, [matrix] commands, keyboard and touch optimized.

        - **fast**\
          Written in Dart following best-practices, incredibly fast GL rendering.

        - **playful**\
          Support for stickers, emoticons and many easter-eggs enhancing your `< polycule >` communication.

        - **compatible**\
          Following the [matrix] spec and interoperable with FluffyChat, nheko, Fractal and Element X.
      '';
      changelog = "https://gitlab.com/polycule_client/polycule/-/tags/v${version}";
      downloadPage = "https://gitlab.com/polycule_client/polycule/";
      homepage = "https://polycule.im/";
      license = lib.licenses.eupl12;
      maintainers = with lib.maintainers; [
        griffi-gh
      ];
    }
    // lib.optionalAttrs (targetFlutterPlatform == "linux") {
      mainProgram = "polycule";
      platforms = lib.platforms.linux;
    };
  }
  // lib.optionalAttrs (targetFlutterPlatform == "linux") {
    nativeBuildInputs = [
      pkg-config
    ];
    buildInputs = [
      alsa-lib
      mpv-unwrapped
    ];
    postInstall = ''
      # https://gitlab.com/polycule_client/polycule/-/blob/main/debian/rules
      # https://gitlab.com/polycule_client/polycule/-/blob/main/debian/polycule.install
      cp assets/logo/logo-circle.svg linux/business.braid.polycule.svg
      install -m 444 -D linux/business.braid.polycule.desktop $out/share/applications/business.braid.polycule.desktop
      install -m 444 -D linux/business.braid.polycule.service $out/share/dbus-1/services/business.braid.polycule.service
      install -m 444 -D linux/business.braid.polycule.svg $out/share/pixmaps/business.braid.polycule.svg
      install -m 444 -D linux/business.braid.polycule.svg $out/share/icons/hicolor/scalable/apps/business.braid.polycule.svg
      install -m 444 -D linux/business.braid.polycule.metainfo.xml $out/share/metainfo/business.braid.polycule.metainfo.xml
    '';
  }
  // lib.optionalAttrs (targetFlutterPlatform == "web") {
    preBuild = ''
      dart compile js web/web_worker.dart -m -o ./web/pkg/web_worker.dart.js
      cp ${vodozemac-wasm}/{vodozemac_bindings_dart.js,vodozemac_bindings_dart_bg.wasm} ./web/pkg/
    '';
  }
)
