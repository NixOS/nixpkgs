{ lib
, buildNpmPackage
, copyDesktopItems
, electron_22
, buildGoModule
, esbuild
, fetchFromGitHub
, fetchpatch
, libdeltachat
, makeDesktopItem
, makeWrapper
, noto-fonts-emoji
, pkg-config
, python3
, roboto
, rustPlatform
, sqlcipher
, stdenv
, CoreServices
}:

let
  libdeltachat' = libdeltachat.overrideAttrs (old: rec {
    version = "1.106.0";
    src = fetchFromGitHub {
      owner = "deltachat";
      repo = "deltachat-core-rust";
      rev = version;
      hash = "sha256-S53ghVFb1qDI7MVNbc2ZlHqDN4VRBFQJCJg2J+w0erc=";
    };
    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${old.pname}-${version}";
      hash = "sha256-k4j814Ao7FAyd0w1nH2fuX1cJKjBkhPw0CVZqNU7Hqs=";
    };
  });
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
in buildNpmPackage rec {
  pname = "deltachat-desktop";
  version = "1.34.2";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    rev = "v${version}";
    hash = "sha256-XOGfKa0eGVZKKKC0Pm2kw48XWWcrxCyDdYzCSKp+wco=";
  };

  patches = [
    (fetchpatch {
      name = "bump-electron-to-22.1.0.patch";
      url = "https://github.com/deltachat/deltachat-desktop/commit/944d2735cda6cd5a95cb83c57484fbaf16720a9c.patch";
      hash = "sha256-kaKi32eFQ3hGLZLjiXmH9qs4GXezcDQ7zTdT2+D8NcQ=";
    })
  ];

  npmDepsHash = "sha256-J3/S/jYQvO/U8StDtYI+jozon0d4VCdeqFX6x1hHzMo=";

  nativeBuildInputs = [
    makeWrapper
    pkg-config
    python3
  ] ++ lib.optionals stdenv.isLinux [
    copyDesktopItems
  ];

  buildInputs = [
    libdeltachat'
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  ESBUILD_BINARY_PATH = "${esbuild'}/bin/esbuild";
  USE_SYSTEM_LIBDELTACHAT = "true";
  VERSION_INFO_GIT_REF = src.rev;

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

    ln -sf ${noto-fonts-emoji}/share/fonts/noto/NotoColorEmoji.ttf \
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

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Email-based instant messaging for Desktop";
    homepage = "https://github.com/deltachat/deltachat-desktop";
    changelog = "https://github.com/deltachat/deltachat-desktop/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    mainProgram = "deltachat";
    maintainers = with maintainers; [ dotlambda ];
  };
}
