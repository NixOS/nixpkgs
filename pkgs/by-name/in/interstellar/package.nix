{
  lib,
  flutter341,
  fetchFromGitHub,
  fetchurl,
  imagemagick,
  alsa-lib,
  libass,
  mpv-unwrapped,
  runCommand,
  yq-go,
  _experimental-update-script-combinators,
  nix-update-script,
  dart,
}:

flutter341.buildFlutterApplication (finalAttrs: {
  pname = "interstellar";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "interstellar-app";
    repo = "interstellar";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WprvuIN7yS5yLR4eUF/M9yG25ZU1Sf1I1myujclF4oM=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = lib.importJSON ./git-hashes.json;

  patches = [ ./emoji_builder.patch ];

  postPatch = ''
    substituteInPlace lib/src/widgets/emoji_picker/emoji_builder.dart \
        --replace-fail "@compact.raw.json@" "${
          fetchurl {
            url = "https://raw.githubusercontent.com/milesj/emojibase/a5fc630a91ca42cddf3f4a66492965600fd3bce8/packages/data/en/compact.raw.json";
            hash = "sha256-OivCYjiBEooRx3zni9jAr3lR0rzpoa3HX2l/a0UwDpE=";
          }
        }" \
        --replace-fail "@messages.raw.json@" "${
          fetchurl {
            url = "https://raw.githubusercontent.com/milesj/emojibase/a5fc630a91ca42cddf3f4a66492965600fd3bce8/packages/data/en/messages.raw.json";
            hash = "sha256-ZQWXZJ5jXxDNQHaOAsxApAt6oanvaEwZ6VXbDA0YeMs=";
          }
        }"
    substituteInPlace lib/src/controller/database/database.dart \
      --replace-fail "const Color.from(alpha: 1, red: 1, green: 1, blue: 1).value32bit" "0xFFFFFFFF" \
      --replace-fail "const Color.from(alpha: 1, red: 0, green: 0, blue: 0).value32bit" "0xFF000000"
  '';

  nativeBuildInputs = [ imagemagick ];

  buildInputs = [
    alsa-lib
    libass
    mpv-unwrapped
  ];

  # run build_runner to make model .part files and language locale gen
  preBuild = ''
    packageRun build_runner build --delete-conflicting-outputs
  '';

  postInstall = ''
    for size in 16 22 24 32 36 48 64 72 96 128 192 256 512 1024; do
        mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
        magick $src/assets/icons/logo.png -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/interstellar.png
    done
    install -D --mode=0644 linux/appimage/interstellar.desktop --target-directory $out/share/applications
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/${finalAttrs.pname}/lib
  '';

  passthru = {
    pubspecSource =
      runCommand "pubspec.lock.json"
        {
          inherit (finalAttrs) src;
          nativeBuildInputs = [ yq-go ];
        }
        ''
          yq eval --output-format=json --prettyPrint $src/pubspec.lock > "$out"
        '';
    updateScript = _experimental-update-script-combinators.sequence [
      (nix-update-script { })
      (
        (_experimental-update-script-combinators.copyAttrOutputToFile "interstellar.pubspecSource" ./pubspec.lock.json)
        // {
          supportedFeatures = [ ];
        }
      )
      {
        command = [
          dart.fetchGitHashesScript
          "--input"
          ./pubspec.lock.json
          "--output"
          ./git-hashes.json
        ];
        supportedFeatures = [ ];
      }
    ];
  };

  meta = {
    description = "App for Mbin/Lemmy/PieFed, connecting you to the fediverse";
    homepage = "https://interstellar.jwr.one";
    license = lib.licenses.agpl3Plus;
    mainProgram = "interstellar";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ JollyDevelopment ];
  };
})
