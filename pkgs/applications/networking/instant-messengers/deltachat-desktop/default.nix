{ lib
, buildNpmPackage
, copyDesktopItems
, electron
, buildGoModule
, esbuild
, fetchFromGitHub
, jq
, deltachat-rpc-server
, libdeltachat
, makeDesktopItem
, makeWrapper
, noto-fonts-color-emoji
, pkg-config
, python3
, roboto
, sqlcipher
, stdenv
, CoreServices
, testers
, deltachat-desktop
}:

let
  esbuild' = esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.19.8";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-f13YbgHFQk71g7twwQ2nSOGA0RG0YYM01opv6txRMuw=";
      };
      vendorHash = "sha256-+BfxCyg0KkDQpHt/wycy/8CTG6YBA/VJvJFhhzUnSiQ=";
    });
  };
in
buildNpmPackage rec {
  pname = "deltachat-desktop";
  version = "1.46.1";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    rev = "v${version}";
    hash = "sha256-90/Wmh0h75i3kvqj3Wo+A3KlKW8LLDWfPza2gDrDY6E=";
  };

  npmDepsHash = "sha256-UzWxMd+DYH5A8Zo1rzi8oIsoKbmzsVbGpr3uWtc02rY=";

  postPatch = ''
    test \
      $(jq -r '.packages."node_modules/@deltachat/jsonrpc-client".version' package-lock.json) \
      = $(pkg-config --modversion deltachat) \
      || (echo "error: libdeltachat version does not match jsonrpc-client" && exit 1)
  '';

  nativeBuildInputs = [
    jq
    makeWrapper
    pkg-config
    python3
  ] ++ lib.optionals stdenv.isLinux [
    copyDesktopItems
  ];

  buildInputs = [
    deltachat-rpc-server
    libdeltachat
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
