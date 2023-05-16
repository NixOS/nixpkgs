{ lib
, buildNpmPackage
, copyDesktopItems
, electron_22
, buildGoModule
, esbuild
, fetchFromGitHub
<<<<<<< HEAD
, libdeltachat
, makeDesktopItem
, makeWrapper
, noto-fonts-color-emoji
, pkg-config
, python3
, roboto
=======
, fetchpatch
, libdeltachat
, makeDesktopItem
, makeWrapper
, noto-fonts-emoji
, pkg-config
, python3
, roboto
, rustPlatform
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sqlcipher
, stdenv
, CoreServices
}:

let
<<<<<<< HEAD
=======
  libdeltachat' = libdeltachat.overrideAttrs (old: rec {
    version = "1.112.8";
    src = fetchFromGitHub {
      owner = "deltachat";
      repo = "deltachat-core-rust";
      rev = "v${version}";
      hash = "sha256-bvXZtgFZx94Sw9Tst620HAhi9kmG8PjtWnghdw2ZF84=";
    };
    cargoDeps = rustPlatform.importCargoLock {
      lockFile = ./Cargo.lock;
      outputHashes = {
        "email-0.0.21" = "sha256-Ys47MiEwVZenRNfenT579Rb17ABQ4QizVFTWUq3+bAY=";
        "encoded-words-0.2.0" = "sha256-KK9st0hLFh4dsrnLd6D8lC6pRFFs8W+WpZSGMGJcosk=";
        "lettre-0.9.2" = "sha256-+hU1cFacyyeC9UGVBpS14BWlJjHy90i/3ynMkKAzclk=";
        "quinn-proto-0.9.2" = "sha256-N1gD5vMsBEHO4Fz4ZYEKZA8eE/VywXNXssGcK6hjvpg=";
      };
    };
  });
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  esbuild' = esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.14.54";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-qCtpy69ROCspRgPKmCV0YY/EOSWiNU/xwDblU0bQp4w=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  };
<<<<<<< HEAD
in
buildNpmPackage rec {
  pname = "deltachat-desktop";
  version = "1.40.3";
=======
in buildNpmPackage rec {
  pname = "deltachat-desktop";
  version = "1.36.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-UVsjka/ptUiSN9aqRESdFZA3uh+FJnJot/YXWUPCJtc=";
  };

  npmDepsHash = "sha256-r0IUQNZJEpY8VE0G/WLdygup32iQ6DxfGkvOgFi7R4k=";
=======
    hash = "sha256-nJF8DPauhEoKC7mibpMJCGsgt9HnwkZp/jiWEEhShBs=";
  };

  npmDepsHash = "sha256-cTvNU4LO74pcw4Ybo9iftEis2yDA2SqGtrs4v+xAi5c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
  ] ++ lib.optionals stdenv.isLinux [
    copyDesktopItems
  ];

  buildInputs = [
<<<<<<< HEAD
    libdeltachat
=======
    libdeltachat'
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ESBUILD_BINARY_PATH = "${esbuild'}/bin/esbuild";
    USE_SYSTEM_LIBDELTACHAT = "true";
    VERSION_INFO_GIT_REF = src.rev;
  };

  preBuild = ''
    rm -r node_modules/deltachat-node/node/prebuilds
  '';

  npmBuildScript = "build4production";

  installPhase = ''
    runHook preInstall

    npm prune --production

    mkdir -p $out/lib/node_modules/deltachat-desktop
    cp -r . $out/lib/node_modules/deltachat-desktop

    awk '!/^#/ && NF' build/packageignore_list \
      | xargs -I {} sh -c "rm -rf $out/lib/node_modules/deltachat-desktop/{}" || true

    install -D build/icon.png \
      $out/share/icons/hicolor/scalable/apps/deltachat.png

<<<<<<< HEAD
    ln -sf ${noto-fonts-color-emoji}/share/fonts/noto/NotoColorEmoji.ttf \
=======
    ln -sf ${noto-fonts-emoji}/share/fonts/noto/NotoColorEmoji.ttf \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      $out/lib/node_modules/deltachat-desktop/html-dist/fonts/noto/emoji
    for font in $out/lib/node_modules/deltachat-desktop/html-dist/fonts/Roboto-*.ttf; do
      ln -sf ${roboto}/share/fonts/truetype/$(basename $font) \
        $out/lib/node_modules/deltachat-desktop/html-dist/fonts
    done

    makeWrapper ${electron_22}/bin/electron $out/bin/deltachat \
      --set LD_PRELOAD ${sqlcipher}/lib/libsqlcipher${stdenv.hostPlatform.extensions.sharedLibrary} \
      --add-flags $out/lib/node_modules/deltachat-desktop

    runHook postInstall
  '';

  desktopItems = lib.singleton (makeDesktopItem {
    name = "deltachat";
    exec = "deltachat %u";
    icon = "deltachat";
    desktopName = "Delta Chat";
    genericName = "Delta Chat";
    comment = meta.description;
    categories = [ "Network" "InstantMessaging" "Chat" ];
    startupWMClass = "DeltaChat";
    mimeTypes = [
      "x-scheme-handler/openpgp4fpr"
      "x-scheme-handler/dcaccount"
      "x-scheme-handler/dclogin"
      "x-scheme-handler/mailto"
    ];
  });

  meta = with lib; {
    description = "Email-based instant messaging for Desktop";
    homepage = "https://github.com/deltachat/deltachat-desktop";
    changelog = "https://github.com/deltachat/deltachat-desktop/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    mainProgram = "deltachat";
    maintainers = with maintainers; [ dotlambda ];
  };
}
