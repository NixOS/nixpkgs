{ stdenv, buildGoModule, fetchFromGitHub, olm, makeDesktopItem }:

buildGoModule rec {
  pname = "gomuks";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "tulir";
    repo = pname;
    rev = "v" + version;
    sha256 = "0sf1nqwimxqql8wm6763jyc5rclhd4zxgg9gfi0qvg5ccm1r1z5q";
  };

  vendorSha256 = "sha256:0n9mwbzjkvlljlns7sby8nb9gm4vj0v4idp1zxv5xssqr5qalihf";

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
