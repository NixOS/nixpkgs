{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  runtimeShell,
  wine,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kakaotalk";
  version = "25.7.3";

  src = fetchurl {
    url = "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe";
    hash = "sha256-c4ufYpQgc3MCmE9Olbkta0YxE+fvN8RYeUvT0B72VMU=";
  };

  icon = fetchurl {
    name = "kakaotalk.png";
    url = "https://t1.kakaocdn.net/kakaocorp/kakaocorp/admin/service/453a624d017900001.png";
    hash = "sha256-1RTNnl3GN84RhvWLjud5RNdHUu88CwsSyfNrko8IqCs=";
  };

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  buildInputs = [
    wine
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    cat <<'EOF' > $out/bin/kakaotalk
    #!${runtimeShell}
    export PATH=${wine}/bin:$PATH
    export WINEARCH=win32
    export WINEPREFIX="''${KAKAOTALK_HOME:-"''${XDG_DATA_HOME:-"''${HOME}/.local/share"}/kakaotalk"}/wine"
    export WINEDLLOVERRIDES="mscoree=;winemenubuilder.exe="
    if [ ! -d "$WINEPREFIX" ] ; then
      mkdir -p "$WINEPREFIX"
      wine ${finalAttrs.src} /S
    fi
    wine "$WINEPREFIX/drive_c/Program Files/Kakao/KakaoTalk/KakaoTalk.exe" &
    KAKAO_PID=$!
    CONFIG_FILE="$WINEPREFIX/drive_c/users/$(whoami)/AppData/Local/Kakao/KakaoTalk/pref.ini"
    for i in {1..30}; do
      if [ -f "$CONFIG_FILE" ]; then
        sed -i 's/use_new_loco = .*/use_new_loco = no/' "$CONFIG_FILE"
        if ! grep -q "use_new_loco" "$CONFIG_FILE"; then
          echo "use_new_loco = no" >> "$CONFIG_FILE"
        fi
        break
      fi
      sleep 1
    done
    wait $KAKAO_PID
    EOF
    chmod +x $out/bin/kakaotalk
    install -Dm644 ${finalAttrs.icon} $out/share/icons/hicolor/256x256/apps/kakaotalk.png
    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "KakaoTalk";
      exec = "kakaotalk";
      icon = "kakaotalk";
      desktopName = "KakaoTalk";
      comment = finalAttrs.meta.description;
      categories = [
        "Network"
        "InstantMessaging"
      ];
      terminal = false;
    })
  ];

  meta = {
    description = "Instant Messaging App operated by Kakao Corporation in South Korea";
    homepage = "https://www.kakaocorp.com/page/service/service/KakaoTalk";
    maintainers = with lib.maintainers; [ aanhlongg ];
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    mainProgram = "kakaotalk";
  };
})
