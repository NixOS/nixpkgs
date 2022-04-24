{ lib
, copyDesktopItems
, electron_16
, esbuild
, fetchFromGitHub
, fetchpatch
, libdeltachat
, makeDesktopItem
, makeWrapper
, nodejs-14_x
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
    version = "1.76.0";
    src = fetchFromGitHub {
      owner = "deltachat";
      repo = "deltachat-core-rust";
      rev = version;
      hash = "sha256-aeYOszOFyLaC1xKswYZLzqoWSFFWOOeOkc+WrtqU0jo=";
    };
    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${old.pname}-${version}";
      hash = "sha256-sBFXcLXpAkX+HzRKrLKaHhi5ieS8Yc/Uf30WcXyWrok=";
    };
  });
  electronExec = if stdenv.isDarwin then
    "${electron_16}/Applications/Electron.app/Contents/MacOS/Electron"
  else
    "${electron_16}/bin/electron";
  esbuild' = esbuild.overrideAttrs (old: rec {
    version = "0.12.29";
    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${version}";
      hash = "sha256-oU++9E3StUoyrMVRMZz8/1ntgPI62M1NoNz9sH/N5Bg=";
    };
  });
in nodejs-14_x.pkgs.deltachat-desktop.override rec {
  pname = "deltachat-desktop";
  version = "1.28.2";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    rev = "v${version}";
    hash = "sha256-jhtriDnt8Yl8eCmUTEyoPjccZV8RNAchMykkkiRpF60=";
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

  postInstall = ''
    rm -r node_modules/deltachat-node/{deltachat-core-rust,prebuilds,src}

    npm run build

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

    makeWrapper ${electronExec} $out/bin/deltachat \
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
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
