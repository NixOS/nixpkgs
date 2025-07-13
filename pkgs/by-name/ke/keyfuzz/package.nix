{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "keyfuzz";
  version = "0.2";

  meta = with lib; {
    description = "Manipulate the scancode/keycode translation tables of keyboard drivers";
    mainProgram = "keyfuzz";
    homepage = "http://0pointer.de/lennart/projects/keyfuzz/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mboes ];
  };

  src = fetchurl {
    url = "https://0pointer.de/lennart/projects/keyfuzz/keyfuzz-0.2.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  configureFlags = [
    "--without-initdir"
    "--disable-lynx"
  ];
}
