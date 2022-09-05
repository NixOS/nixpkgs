{ lib
, copyDesktopItems
, electron_18
, buildGoModule
, esbuild
, fetchFromGitHub
, libdeltachat
, makeDesktopItem
, makeWrapper
, nodePackages
, noto-fonts-emoji
, pkg-config
, roboto
, rustPlatform
, sqlcipher
, stdenv
, CoreServices
}:

let
  libdeltachat' = libdeltachat.overrideAttrs (old: rec {
    version = "1.86.0";
    src = fetchFromGitHub {
      owner = "deltachat";
      repo = "deltachat-core-rust";
      rev = version;
      hash = "sha256-VLS93Ffeit2rVmXxYkXcnf8eDA3DC2/wKYZTh56QCk0=";
    };
    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${old.pname}-${version}";
      hash = "sha256-4rpoDQ3o0WdWg/TmazTI+J0hL/MxwHcNMXWMq7GE7Tk=";
    };
  });
  esbuild' = esbuild.override {
    buildGoModule = args: buildGoModule (args // rec {
      version = "0.12.29";
      src = fetchFromGitHub {
        owner = "evanw";
        repo = "esbuild";
        rev = "v${version}";
        hash = "sha256-oU++9E3StUoyrMVRMZz8/1ntgPI62M1NoNz9sH/N5Bg=";
      };
      vendorSha256 = "sha256-QPkBR+FscUc3jOvH7olcGUhM6OW4vxawmNJuRQxPuGs=";
    });
  };
in nodePackages.deltachat-desktop.override rec {
  pname = "deltachat-desktop";
  version = "1.30.1";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    rev = "v${version}";
    hash = "sha256-gZjZbXiqhFVfThZOsvL/nKkf6MX+E3KB5ldEAIuzBYA=";
  };

  nativeBuildInputs = [
    makeWrapper
    pkg-config
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

  preRebuild = ''
    substituteInPlace package.json \
      --replace "node ./bin/check-nodejs-version.js" true
  '';

  postInstall = ''
    rm -r node_modules/deltachat-node/node/prebuilds

    npm run build4production

    npm prune --production

    install -D $out/lib/node_modules/deltachat-desktop/build/icon.png \
      $out/share/icons/hicolor/scalable/apps/deltachat.png

    awk '!/^#/ && NF' build/packageignore_list \
      | xargs -I {} sh -c "rm -rf {}" || true

    ln -sf ${noto-fonts-emoji}/share/fonts/noto/NotoColorEmoji.ttf \
      $out/lib/node_modules/deltachat-desktop/html-dist/fonts/noto/emoji
    for font in $out/lib/node_modules/deltachat-desktop/html-dist/fonts/Roboto-*.ttf; do
      ln -sf ${roboto}/share/fonts/truetype/$(basename $font) \
        $out/lib/node_modules/deltachat-desktop/html-dist/fonts
    done

    makeWrapper ${electron_18}/bin/electron $out/bin/deltachat \
      --set LD_PRELOAD ${sqlcipher}/lib/libsqlcipher${stdenv.hostPlatform.extensions.sharedLibrary} \
      --add-flags $out/lib/node_modules/deltachat-desktop
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
    mimeTypes = [ "x-scheme-handler/openpgp4fpr" "x-scheme-handler/mailto" ];
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
