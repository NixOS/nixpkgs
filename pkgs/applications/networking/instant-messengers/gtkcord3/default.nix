{ stdenv, buildGoModule, fetchFromGitHub
, pkg-config, makeDesktopItem
, gtk3, libhandy
}:

buildGoModule rec {
  pname = "gtkcord3";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "diamondburned";
    repo = pname;
    rev = "v" + version;
    sha256 = "sha256-zdku9lpoanV/wDq8H+0bw4yaVaeZxYT2RP1+UDQAJlk=";
  };

  vendorSha256 = "sha256-Ngq1RUc+w3GbslYJhb8U7OvlkRO6ANn8ICRLhkFH+E8=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 libhandy ];

  subPackages = [ "." ];

  postInstall = ''
    cp -r ${
      makeDesktopItem {
        name = "gtkcord3";
        exec = "@out@/bin/gtkcord3";
        terminal = "true";
        desktopName = "Gtkcord3";
        genericName = "Discord client";
        categories = "Network;Chat";
        comment = meta.description;
      }
    }/* $out/
    substituteAllInPlace $out/share/applications/*
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/diamondburned/gtkcord3";
    description = "A Gtk3 Discord client in Golang";
    license = licenses.gpl3;
    maintainers = with maintainers; [ colemickens ];
    platforms = platforms.unix;
  };
}
