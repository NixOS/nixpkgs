{ lib
, stdenv
, substituteAll
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
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v${version}";
    sha256 = "bTOfnEmJHTuniewH//SugNNDuKIFMQb1Safs0UVKH1c=";
  };

  vendorSha256 = "PuNROoxL7UmcuYDgfnsMUsGk9i1jnQyWtaUmT7vXdKE=";

  doCheck = false;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ olm ];

  # Upstream issue: https://github.com/tulir/gomuks/issues/260
  patches = lib.optional stdenv.isLinux (substituteAll {
    src = ./hardcoded_path.patch;
    soundTheme = sound-theme-freedesktop;
  });

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
      --prefix PATH : "${lib.makeBinPath (lib.optionals stdenv.isLinux [ libnotify pulseaudio ])}"
  '';

  meta = with lib; {
    homepage = "https://maunium.net/go/gomuks/";
    description = "A terminal based Matrix client written in Go";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ chvp emily ];
    platforms = platforms.unix;
  };
}
