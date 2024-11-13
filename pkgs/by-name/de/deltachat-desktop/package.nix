{ lib
, buildNpmPackage
, copyDesktopItems
, electron_30
, buildGoModule
, esbuild
, fetchFromGitHub
, jq
, deltachat-rpc-server
, makeDesktopItem
, makeWrapper
, noto-fonts-color-emoji
, pkg-config
, python3
, roboto
, sqlcipher
, stdenv
, darwin
, testers
, deltachat-desktop
}:

let
  electron = electron_30;
  esbuild' = esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.19.12";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-NQ06esCSU6YPvQ4cMsi3DEFGIQGl8Ff6fhdTxUAyGvo=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  };
in
buildNpmPackage rec {
  pname = "deltachat-desktop";
  version = "1.46.8";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    rev = "v${version}";
    hash = "sha256-17JhaanYEySoDuLYFMc4vB3wVlCucMh3Jk2Uu9PqUdQ=";
  };

  npmDepsHash = "sha256-+74koym1lL2rk5n06i7JgcXmX+yW4zgqRfdH6ryXe0s=";

  nativeBuildInputs = [
    jq
    makeWrapper
    pkg-config
    python3
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  buildInputs = [
    deltachat-rpc-server
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreServices
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ESBUILD_BINARY_PATH = "${esbuild'}/bin/esbuild";
    USE_SYSTEM_LIBDELTACHAT = "true";
    VERSION_INFO_GIT_REF = src.rev;
  };

  preBuild = ''
    test \
      $(jq -r '.packages."node_modules/@deltachat/jsonrpc-client".version' package-lock.json) \
      = ${deltachat-rpc-server.version} \
      || (echo "error: deltachat-rpc-server version does not match jsonrpc-client" && exit 1)

    test \
      $(jq -r '.packages."node_modules/electron".version' package-lock.json | grep -E -o "^[0-9]+") \
      = ${lib.versions.major electron.version} \
      || (echo 'error: electron version doesn not match package-lock.json' && exit 1)

    rm node_modules/@deltachat/stdio-rpc-server-*/deltachat-rpc-server
    ln -s ${lib.getExe deltachat-rpc-server} node_modules/@deltachat/stdio-rpc-server-linux-*
  '';

  npmBuildScript = "build4production";

  installPhase = ''
    runHook preInstall

    npm prune --production

    mkdir -p $out/lib/node_modules/deltachat-desktop
    cp -r . $out/lib/node_modules/deltachat-desktop

    awk '!/^#/ && NF' build/packageignore_list \
      | xargs -I {} sh -c "rm -rf $out/lib/node_modules/deltachat-desktop/{}" || true

    # required for electron to import index.js as a module
    cp package.json $out/lib/node_modules/deltachat-desktop

    install -D build/icon.png \
      $out/share/icons/hicolor/scalable/apps/deltachat.png

    ln -sf ${noto-fonts-color-emoji}/share/fonts/noto/NotoColorEmoji.ttf \
      $out/lib/node_modules/deltachat-desktop/html-dist/fonts/noto/emoji
    for font in $out/lib/node_modules/deltachat-desktop/html-dist/fonts/Roboto-*.ttf; do
      ln -sf ${roboto}/share/fonts/truetype/$(basename $font) \
        $out/lib/node_modules/deltachat-desktop/html-dist/fonts
    done

    makeWrapper ${lib.getExe electron} $out/bin/deltachat \
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

  passthru.tests = {
    version = testers.testVersion {
      package = deltachat-desktop;
    };
  };

  meta = with lib; {
    description = "Email-based instant messaging for Desktop";
    homepage = "https://github.com/deltachat/deltachat-desktop";
    changelog = "https://github.com/deltachat/deltachat-desktop/blob/${src.rev}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    mainProgram = "deltachat";
    maintainers = with maintainers; [ dotlambda ];
  };
}
