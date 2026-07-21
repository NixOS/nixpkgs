{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  inkscape,
  xcursorgen,
}:

stdenvNoCC.mkDerivation rec {
  pname = "numix-cursor-theme";
  version = "1.2";

  src = fetchFromGitHub {
    owner = "numixproject";
    repo = "numix-cursor-theme";
    rev = "v${version}";
    sha256 = "1q3w5i0h3ly6i7s9pqjdrb14kp89i78s0havri7lhiqyxizjvcvh";
  };

  nativeBuildInputs = [
    inkscape
    xcursorgen
  ];

  buildPhase = ''
    patchShebangs .
    HOME=$TMP ./build.sh
  '';

  installPhase = ''
    install -dm 755 $out/share/icons
    cp -dr --no-preserve='ownership' Numix-Cursor{,-Light} $out/share/icons/
  '';

  meta = {
    description = "Numix cursor theme";
    homepage = "https://numixproject.github.io";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
