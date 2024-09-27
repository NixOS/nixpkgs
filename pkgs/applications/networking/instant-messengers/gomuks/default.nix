{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, makeDesktopItem
, makeWrapper
, libnotify
, olm
, pulseaudio
, sound-theme-freedesktop
}:

buildGoModule rec {
  pname = "gomuks";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bDJXo8d9K5UO599HDaABpfwc9/dJJy+9d24KMVZHyvI=";
  };

  vendorHash = "sha256-0my58bVKLWbdTwhAnXMruNjujd07NXFn4bkRe1cUYpE=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ olm ];

  postInstall = ''
    cp -r ${
      makeDesktopItem {
        name = "net.maunium.gomuks.desktop";
        exec = "@out@/bin/gomuks";
        terminal = true;
        desktopName = "Gomuks";
        genericName = "Matrix client";
        categories = [ "Network" "Chat" ];
        comment = meta.description;
      }
    }/* $out/
    substituteAllInPlace $out/share/applications/*
    wrapProgram $out/bin/gomuks \
      --prefix PATH : "${lib.makeBinPath (lib.optionals stdenv.hostPlatform.isLinux [ libnotify pulseaudio ])}" \
      --set-default GOMUKS_SOUND_NORMAL "${sound-theme-freedesktop}/share/sounds/freedesktop/stereo/message-new-instant.oga" \
      --set-default GOMUKS_SOUND_CRITICAL "${sound-theme-freedesktop}/share/sounds/freedesktop/stereo/complete.oga"
  '';

  meta = with lib; {
    homepage = "https://maunium.net/go/gomuks/";
    description = "A terminal based Matrix client written in Go";
    mainProgram = "gomuks";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ chvp ];
  };
}
