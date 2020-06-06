{ stdenv, buildGoModule, fetchFromGitHub, olm, makeDesktopItem }:

buildGoModule rec {
  pname = "gomuks";
  version = "0.1.0";

  goPackagePath = "maunium.net/go/gomuks";
  patches = [ ./gomod.patch ];

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v" + version;
    sha256 = "1dcqkyxiqiyivzn85fwkjy8xs9yk89810x9mvkaiz0dx3ha57zhi";
  };

  vendorSha256 = "1mfi167mycnnlq8dwh1kkx6drhhi4ib58aad5fwc90ckdaq1rpb7";

  buildInputs = [ olm ];

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
