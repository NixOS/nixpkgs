{
  lib,
  stdenv,
  fetchFromGitHub,
  flutter329,
  rustPlatform,
  replaceVars,
  imagemagick,
}:
let
  pname = "aria-for-misskey"; # "Alias aria is still in all-packages.nix"
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "poppingmoon";
    repo = "aria";
    tag = "v${version}";
    hash = "sha256-ueh0aChHViK2XqpSPmrafgfEZ8GwbOyd9hPm6/37wl0=";
  };

  pubspecName = "aria";

  rustLib = rustPlatform.buildRustPackage {
    pname = "${pname}-rust-lib";
    inherit version src;
    sourceRoot = "${src.name}/rust";
    useFetchCargoVendor = true;
    cargoHash = "sha256-8PIhRSPJoa+Jza2SWYXy2lIJczLuMegK7noEEVWObzc=";
    passthru.libraryPath = "lib/librust_lib_${pubspecName}.so";
  };
in

flutter329.buildFlutterApplication {
  inherit pname version src;

  patches = [
    ./no-csd.patch
  ];

  # XXX: to generate:
  # curl https://raw.githubusercontent.com/poppingmoon/aria/refs/tags/v${version}/pubspec.lock
  #   | yq . -o=json > pubspec.lock.json
  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    flutter_apns_only = "sha256-5KlICoKqekSE4LCzd1MP+o8Ezq0xLZmzeAQZExXBalM=";
    flutter_highlighting = "sha256-YtCAFbFrSwjW4WRqMXWty60Q4GFVX0OTIBqn2GsLRj4=";
    highlighting = "sha256-IedjKNGFBSbU4vu5x8GI28WL4uJ8B/kvw6iGkX2+uGg=";
    image_compression = "sha256-9RBjKId8TYdx3O0wT2We8FbCiJYkqJlyBY7TYDUxsMg=";
    # this one takes a LONG time to fetch;
    # the "removing '.git'..." directories step took *over an hour* or so for me
    # DO NOT PANIC IF IT LOOKS STUCK
    material_off_icons = "sha256-jMO1abOm1YgFAAbFaTFgTjrmQGW6d7Z1J4o2wTynto4=";
    mfm_parser = "sha256-GJUTuX3cPYe3Weo5VzYVXJuvc0EmrLmxCGgStYfH1lk=";
    misskey_dart = "sha256-5W58lEcIVzWMaiNZchL1GmkONmyHzwQVs0Jq4M9e9+k=";
    receive_sharing_intent = "sha256-8D5ZENARPZ7FGrdIErxOoV3Ao35/XoQ2tleegI42ZUY=";
    tinycolor2 = "sha256-RGjhuX6487TJ2ofNdJS1FCMl6ciKU0qkGKg4yfkPE+w=";
    twemoji_v2 = "sha256-Gi9PIMpw4NWkk357X+iZPUhzIKMDg5WdzTPHvJDBzSg=";
    unifiedpush_android = "sha256-9CqjGc4isQ7U2fU0YusnQUwpDlqmrD/eXhnIGHYrfHU=";
    unifiedpush_linux = "sha256-9CqjGc4isQ7U2fU0YusnQUwpDlqmrD/eXhnIGHYrfHU=";
    webcrypto = "sha256-uU0jaD8894YmztduZu4hieyEqK2kGnzY5/6B/QTs8Rw=";
  };

  customSourceBuilders = {
    rust_lib_aria =
      { version, src, ... }:
      stdenv.mkDerivation rec {
        pname = "rust_lib_${pubspecName}";
        inherit version src;
        inherit (src) passthru;

        patches = [
          (replaceVars ./cargokit.patch {
            output_lib = "${rustLib}/${rustLib.passthru.libraryPath}";
          })
        ];

        installPhase = ''
          runHook preInstall
          cp -r . $out
          runHook postInstall
        '';
      };
  };

  nativeBuildInputs = [
    imagemagick
  ];

  postInstall =
    let
      # android icon has transparent background, normal one doesn't
      iconPath = "$out/app/${pname}/data/flutter_assets/assets/aria_android.png";
    in
    ''
      mkdir -p $out/share/pixmaps
      install -Dm644 ${iconPath} $out/share/pixmaps/aria-for-misskey.png
      for size in 16 32 64 128 256 512; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick ${iconPath} -resize "$size"x"$size" \
          $out/share/icons/hicolor/"$size"x"$size"/apps/aria-for-misskey.png
      done
    '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/${pname}/lib
  '';

  meta = {
    description = "Cross-platform Misskey client built with Flutter";
    # based on snap metadata
    longDescription = ''
      Aria is a client app for Misskey, a federated social media platform.

      - Supports most of Misskey's features.\
        Aria supports most of the functions available in Misskey,
        including viewing various types of timelines, posting notes,
        editing clips, lists or antennas, etc.

      - Swipe to switch between multiple accounts (of multiple servers)\
        Aria makes it easy to view different timelines by saving the timelines you want to view as tabs.
        Adding any account's timeline to a tab makes it easy to follow topics across servers.

      - Based on the design of the official Misskey Web client\
        The user interface is designed to look familiar, similar to the official Misskey front-end.
        It also supports note decoration with MFM.

      - Highly customizable\
        Numerous settings, such as reaction display size and display of user icons,
        can be changed and adjusted to your liking.
        Also, you can change the theme to decorate the application with your favorite colors.
    '';
    homepage = "https://github.com/poppingmoon/aria";
    changelog = "https://github.com/poppingmoon/aria/releases/tag/${src.tag}";
    downloadPage = "https://github.com/poppingmoon/aria/releases";
    license = lib.licenses.agpl3Only;
    mainProgram = "aria";
    platforms = lib.platforms.linux; # mac? idk
    maintainers = with lib.maintainers; [
      griffi-gh
    ];
  };
}
