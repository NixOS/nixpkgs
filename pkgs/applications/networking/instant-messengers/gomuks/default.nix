{ stdenv, buildGoModule, fetchFromGitHub, olm, makeDesktopItem }:

buildGoModule rec {
  pname = "gomuks";
  version = "0.1.2";

  goPackagePath = "maunium.net/go/gomuks";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v" + version;
    sha256 = "11bainw4w9fdrhv2jm0j9fw0f7r4cxlblyazbhckgr4j9q900383";
  };

  vendorSha256 = "11rk7pma6dr6fsyz8hpjyr7nc2c7ichh5m7ds07m89gzk6ar55gb";

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
