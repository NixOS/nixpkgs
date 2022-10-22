{ lib
, stdenv
, fetchFromGitHub
, copyDesktopItems
, fontconfig
, freetype
, libX11
, libXext
, libXft
, libXinerama
, makeDesktopItem
, pkg-config
, which
}:

stdenv.mkDerivation rec {
  pname = "berry";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "JLErvin";
    repo = pname;
    rev = version;
    hash = "sha256-cs1NVwaANMIteCQuGqPcEWuUbfJulhjmfWnlU8Eb2OM=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    pkg-config
    which
  ];

  buildInputs =[
    libX11
    libXext
    libXft
    libXinerama
    fontconfig
    freetype
  ];

  postPatch = ''
    sed -i --regexp-extended 's/(pkg_verstr=").*(")/\1${version}\2/' configure
  '';

  preConfigure = ''
    patchShebangs configure
  '';

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      exec = "berry";
      comment = meta.description;
      desktopName = "Berry Window Manager";
      genericName = "Berry Window Manager";
      categories = [ "Utility" ];
    })
  ];

  meta = with lib; {
    homepage = "https://berrywm.org/";
    description = "A healthy, bite-sized window manager";
    longDescription = ''
      berry is a healthy, bite-sized window manager written in C for unix
      systems. Its main features include:

      - Controlled via a powerful command-line client, allowing users to control
        windows via a hotkey daemon such as sxhkd or expand functionality via
        shell scripts.
      - Small, hackable source code.
      - Extensible themeing options with double borders, title bars, and window
        text.
      - Intuitively place new windows in unoccupied spaces.
      - Virtual desktops.
    '';
    license = licenses.mit;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
