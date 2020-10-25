{ stdenv, buildGoModule, fetchFromGitHub, olm, makeDesktopItem }:

buildGoModule rec {
  pname = "gomuks";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v" + version;
    sha256 = "0xa4ch4p48w6sd0f4s1sp0hl1w4fvzhff7w2ar19ki0ydy5g368n";
  };

  vendorSha256 = "1rhvwk8bdbbffhx2d03a8p9jc5c8v3pi7kw1dmyyngz6p7wq1g0x";

  doCheck = false;

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
