{ stdenv, buildGoModule, fetchFromGitHub, makeDesktopItem }:

buildGoModule rec {
  pname = "gomuks";
  version = "2020-03-20";

  goPackagePath = "maunium.net/go/gomuks";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "bce30e32a049b3ee76081c8d3881a3820b0e7341";
    sha256 = "0f7i88vrvl1xl4hmjplq3wwihqwijbgxy6nk5fkvc8pfmm5hsjcs";
  };

  modSha256 = "10w0bjhnf6bbqx5jbgfv2jxxyqswzx25p64kkjmvh5qamjzpbjz2";

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
  '';

  meta = with stdenv.lib; {
    homepage = "https://maunium.net/go/gomuks/";
    description = "A terminal based Matrix client written in Go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tilpner emily ];
    platforms = platforms.unix;
  };
}
