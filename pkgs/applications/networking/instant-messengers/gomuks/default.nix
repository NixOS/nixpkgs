{ lib, stdenv, buildGoModule, fetchFromGitHub, olm, makeDesktopItem }:

buildGoModule rec {
  pname = "gomuks";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v${version}";
    sha256 = "169xyd44jyfh5njwmhsmkah8njfgnp9q9c2b13p0ry5saicwm5h5";
  };

  vendorSha256 = "1l8qnz0qy90zpywfx7pbkqpxg7rkvc9j622zcmkf38kdc1z6w20a";

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

  meta = with lib; {
    homepage = "https://maunium.net/go/gomuks/";
    description = "A terminal based Matrix client written in Go";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tilpner emily ];
    platforms = platforms.unix;
  };
}
