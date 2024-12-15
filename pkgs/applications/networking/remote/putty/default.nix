{ stdenv, lib, fetchurl, cmake, perl, pkg-config
, gtk3, ncurses, darwin, copyDesktopItems, makeDesktopItem
}:

stdenv.mkDerivation rec {
  version = "0.81";
  pname = "putty";

  src = fetchurl {
    urls = [
      "https://the.earth.li/~sgtatham/putty/${version}/${pname}-${version}.tar.gz"
      "ftp://ftp.wayne.edu/putty/putty-website-mirror/${version}/${pname}-${version}.tar.gz"
    ];
    hash = "sha256-y4sAqU9FNJTjRaPfKB16PtJrsN1+NiZPFFIG+IV2Of4=";
  };

  nativeBuildInputs = [ cmake perl pkg-config copyDesktopItems ];
  buildInputs = lib.optionals stdenv.hostPlatform.isUnix [
    gtk3 ncurses
  ] ++ lib.optional stdenv.hostPlatform.isDarwin darwin.apple_sdk.libs.utmp;
  enableParallelBuilding = true;

  desktopItems = [
    (makeDesktopItem {
      name = "PuTTY SSH Client";
      exec = "putty";
      icon = "putty";
      desktopName = "PuTTY";
      comment = "Connect to an SSH server with PuTTY";
      categories = [ "GTK" "Network" ];
    })
    (makeDesktopItem {
      name = "PuTTY Terminal Emulator";
      exec = "pterm";
      icon = "pterm";
      desktopName = "Pterm";
      comment = "Start a PuTTY terminal session";
      categories = [ "GTK" "System" "Utility" "TerminalEmulator" ];
    })
  ];

  meta = with lib; {
    description = "Free Telnet/SSH Client";
    longDescription = ''
      PuTTY is a free implementation of Telnet and SSH for Windows and Unix
      platforms, along with an xterm terminal emulator.
      It is written and maintained primarily by Simon Tatham.
    '';
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/putty/";
    license = licenses.mit;
    platforms = platforms.unix ++ platforms.windows;
  };
}
