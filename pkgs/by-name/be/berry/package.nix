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

stdenv.mkDerivation (finalAttrs: {
  pname = "berry";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "JLErvin";
    repo = "berry";
    rev = finalAttrs.version;
    hash = "sha256-xMJRiLNtwVRQf9HiCF3ClLKEmdDNxcY35IYxe+L7+Hk=";
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

  outputs = [ "out" "man" ];

  strictDeps = true;

  postPatch = ''
    sed -i --regexp-extended 's/(pkg_verstr=").*(")/\1${finalAttrs.version}\2/' configure
  '';

  preConfigure = ''
    patchShebangs configure
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "berry";
      exec = "berry";
      comment = "A healthy, bite-sized window manager";
      desktopName = "Berry Window Manager";
      genericName = "Berry Window Manager";
      categories = [ "Utility" ];
    })
  ];

  meta = {
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
    license = lib.licenses.mit;
    mainProgram = "berry";
    maintainers = [ lib.maintainers.AndersonTorres ];
    inherit (libX11.meta) platforms;
  };
})
