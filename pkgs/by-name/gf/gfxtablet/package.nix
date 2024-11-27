{lib, stdenv, fetchFromGitHub, linuxHeaders}:

stdenv.mkDerivation rec {
  version = "1.4";
  pname = "gfxtablet-uinput-driver";

  buildInputs = [
    linuxHeaders
  ];

  src = fetchFromGitHub {
    owner = "rfc2822";
    repo = "GfxTablet";
    rev = "android-app-${version}";
    sha256 = "1i2m98yypfa9phshlmvjlgw7axfisxmldzrvnbzm5spvv5s4kvvb";
  };

  preBuild = "cd driver-uinput";

  installPhase = ''
    mkdir -p "$out/bin"
    cp networktablet "$out/bin"
    mkdir -p "$out/share/doc/gfxtablet/"
    cp ../*.md "$out/share/doc/gfxtablet/"
  '';

  meta = {
    description = "Uinput driver for Android GfxTablet tablet-as-input-device app";
    mainProgram = "networktablet";
    license = lib.licenses.mit ;
    maintainers = [lib.maintainers.raskin];
    platforms = lib.platforms.linux;
  };
}
