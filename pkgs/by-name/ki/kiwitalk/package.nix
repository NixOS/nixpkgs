{ lib
, fetchFromGitHub
, stdenv
, rustc
, rustPlatform
, cargo
, cargo-tauri
, desktop-file-utils
, openssl
, libayatana-appindicator
, webkitgtk
, pkg-config
, pnpm
, nodejs
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kiwitalk";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "KiwiTalk";
    repo = "KiwiTalk";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Th8q+Zbc102fIk2v7O3OOeSriUV/ydz60QwxzmS7AY8=";
  };

  postPatch = ''
    substituteInPlace $cargoDepsCopy/libappindicator-sys-*/src/lib.rs \
      --replace-warn "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
    ln -sf ${./Cargo.lock} Cargo.lock
  '';

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    hash = "sha256-gf3vmKUta8KksUOxyhQS4UO6ycAJDfEicyXVGMW8+4c=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "tauri-plugin-log-0.0.0" = "sha256-8BrFf7vheMJIaZD0oXpi8V4hmUJFzHJmkcRtPL1/J48=";
      "tauri-plugin-single-instance-0.0.0" = "sha256-8BrFf7vheMJIaZD0oXpi8V4hmUJFzHJmkcRtPL1/J48=";
    };
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    cargo
    rustc
    cargo-tauri.hook
    desktop-file-utils
    nodejs
    pnpm.configHook
    pkg-config
  ];

  buildInputs = [
    openssl
    libayatana-appindicator
    webkitgtk
  ];

  postInstall = lib.optionalString stdenv.isLinux ''
    desktop-file-edit \
      --set-comment "An UNOFFICIAL cross-platform KakaoTalk client" \
      --set-key="Categories" --set-value="Network;InstantMessaging;" \
      $out/share/applications/kiwi-talk.desktop
  '';

  meta = with lib; {
    description = "UNOFFICIAL cross-platform KakaoTalk client written in TypeScript & Rust (SolidJS, tauri)";
    homepage = "https://github.com/KiwiTalk/KiwiTalk";
    maintainers = with maintainers; [ honnip ];
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "kiwi-talk";
  };
})
