{ lib
, copyDesktopItems
, electron
, esbuild
, fetchFromGitHub
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
  electronExec = if stdenv.isDarwin then
    "${electron}/Applications/Electron.app/Contents/MacOS/Electron"
  else
    "${electron}/bin/electron";
in nodePackages.deltachat-desktop.override rec {
  pname = "deltachat-desktop";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "deltachat";
    repo = "deltachat-desktop";
    rev = "v${version}";
    sha256 = "0in6w2vl4ypgjb9gfhyh77vg05ni5p3z24lah7wvvhywcpv1jp2n";
  };

  nativeBuildInputs = [
    esbuild
    makeWrapper
    pkg-config
  ] ++ lib.optionals stdenv.isLinux [
    copyDesktopItems
  ];

  buildInputs = [
    libdeltachat
  ] ++ lib.optionals stdenv.isDarwin [
    CoreServices
  ];

  ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
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
    categories = "Network;InstantMessaging;Chat;";
    extraEntries = ''
      StartupWMClass=DeltaChat
      MimeType=x-scheme-handler/openpgp4fpr;x-scheme-handler/mailto;
    '';
  });

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Email-based instant messaging for Desktop";
    homepage = "https://github.com/deltachat/deltachat-desktop";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
