{ lib
, copyDesktopItems
, electron
, esbuild
, fetchFromGitHub
, fetchpatch
, libdeltachat
, makeDesktopItem
, makeWrapper
, nodePackages
, pkg-config
, rustPlatform
, stdenv
, CoreServices
}:

let
  libdeltachat' = libdeltachat.overrideAttrs (old: rec {
    version = "1.70.0";
    src = fetchFromGitHub {
      owner = "deltachat";
      repo = "deltachat-core-rust";
      rev = version;
      hash = "sha256-702XhFWvFG+g++3X97sy6C5DMNWogv1Xbr8QPR8QyLo=";
    };
    cargoDeps = rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${old.pname}-${version}";
      hash = "sha256-MiSGJMXe8vouv4XEHXq274FHEvBMtd7IX6DyNJIWYeU=";
    };
  });
  electronExec = if stdenv.isDarwin then
    "${electron}/Applications/Electron.app/Contents/MacOS/Electron"
  else
    "${electron}/bin/electron";
  esbuild' = esbuild.overrideAttrs (old: rec {
    version = "0.12.29";
    src = fetchFromGitHub {
      owner = "evanw";
      repo = "esbuild";
      rev = "v${version}";
      hash = "sha256-oU++9E3StUoyrMVRMZz8/1ntgPI62M1NoNz9sH/N5Bg=";
    };
  });
in nodePackages.deltachat-desktop.override rec {
  pname = "deltachat-desktop";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    rev = "v${version}";
    hash = "sha256-IDyGV2+/+wHp5N4G10y5OHvw2yoyVxWx394xszIYoj4=";
  };

  nativeBuildInputs = [
    esbuild
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

  postInstall = let
    keep = lib.concatMapStringsSep " " (file: "! -name ${file}") [
      "_locales" "build" "html-dist" "images" "index.js"
      "node_modules" "themes" "tsc-dist"
    ];
  in ''
    rm -r node_modules/deltachat-node/{deltachat-core-rust,prebuilds,src}

    patchShebangs node_modules/sass/sass.js

    npm run build

    npm prune --production

    find . -mindepth 1 -maxdepth 1 ${keep} -print0 | xargs -0 rm -r

    mkdir -p $out/share/icons/hicolor/scalable/apps
    ln -s $out/lib/node_modules/deltachat-desktop/build/icon.png \
      $out/share/icons/hicolor/scalable/apps/deltachat.png

    makeWrapper ${electronExec} $out/bin/deltachat \
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
