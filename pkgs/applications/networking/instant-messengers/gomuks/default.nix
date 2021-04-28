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
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v${version}";
    sha256 = "0g0aa6h6bm00mdgkb38wm66rcrhqfvs2xj9rl04bwprsa05q5lca";
  };

  vendorSha256 = "14ya5advpv4q5il235h5dxy8c2ap2yzrvqs0sjqgw0v1vm6vpwdx";

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
        terminal = "true";
        desktopName = "Gomuks";
        genericName = "Matrix client";
        categories = "Network;Chat";
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
